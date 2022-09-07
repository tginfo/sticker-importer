import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sticker_import/utils/debugging.dart';

import 'account.dart';

class VkStickerStore {
  VkStickerStore({required this.account});

  final Account account;

  Stream<VkStickerStoreSection> _getSectionsStream() async* {
    final req = await account.vk.call(
      'catalog.getStickers',
      <String, String>{},
      isTraced: false,
    );

    final sections =
        (((req.asJson()['response'] as Map<String, dynamic>)['catalog']
                as Map<String, dynamic>)['sections'] as List<dynamic>)
            .cast<Map<String, dynamic>>();

    for (final section in sections) {
      yield VkStickerStoreSection(
        id: section['id'] as String,
        title: section['title'] as String,
        account: account,
      );
    }
  }

  Future<List<VkStickerStoreSection>> getSections() {
    return _getSectionsStream().toList();
  }
}

class _BackgroundComputationResultVkStoreLayout {
  final List<VkStickerStoreLayout> list;
  final String? nextFrom;

  const _BackgroundComputationResultVkStoreLayout(this.list, this.nextFrom);
}

_BackgroundComputationResultVkStoreLayout _decodeRequest(
    List<List<int>> response) {
  final list = <VkStickerStoreLayout>[];
  final data =
      jsonDecode(utf8.decode(response.expand((element) => element).toList()))
          as Map<String, dynamic>;
  final packs = data['response']['stickers_packs'] as Map<String, dynamic>? ??
      <String, dynamic>{};

  VkStickerStoreStickerAndPack findSticker(int id) {
    for (final pack in packs.values) {
      final stickers = pack['product']['stickers'] as List<dynamic>;
      for (final sticker in stickers) {
        if (sticker['sticker_id'] == id) {
          final p = VkStickerStorePack.fromJson(pack as Map<String, dynamic>);
          return VkStickerStoreStickerAndPack(
              sticker: p.styles[0].stickers!.firstWhere(
                (element) => element.id == id,
              ),
              pack: p);
        }
      }
    }

    iLog('No pack provided for a sticker ID $id');
    return VkStickerStoreStickerAndPack(
      sticker: VkStickerStoreSticker(
        id: id,
        image: 'https://vk.com/images/sticker/1-$id-512',
        thumbnail: 'https://vk.com/images/sticker/1-$id-128b',
      ),
      pack: null,
    );
  }

  final blocks = (data['response']['section']['blocks'] as List<dynamic>)
      .cast<Map<String, dynamic>>();
  final nextFrom = data['response']['section']['next_from'] as String?;

  for (final block in blocks) {
    if (block['data_type'] == 'stickers_packs') {
      final packList = (block['stickers_pack_ids'] as List<dynamic>)
          .map((dynamic e) => e.toString());

      list.add(VkStickerStoreLayoutPackList(
        type: (block['layout']['name'] == 'slider')
            ? VkStickerStoreLayoutPackListType.slider
            : VkStickerStoreLayoutPackListType.list,
        packs: [
          for (final packId in packList)
            VkStickerStorePack.fromJson(
              packs[packId] as Map<String, dynamic>,
            )
        ],
      ));
    } else if (block['data_type'] == 'stickers') {
      list.add(VkStickerStoreLayoutStickersList(stickers: [
        for (final sticker
            in (block['sticker_ids'] as List<dynamic>).cast<int>())
          findSticker(sticker),
      ]));
    } else if (block['layout']['name'] == 'header' ||
        block['layout']['name'] == 'header_compact') {
      list.add(VkStickerStoreLayoutHeader(
        title: block['layout']['title'] as String,
        buttons: [
          for (final button
              in (block['buttons'] as List<dynamic>? ?? <dynamic>[])
                  .cast<Map<String, dynamic>>())
            if (button['action']['type'] == 'open_section')
              VkStickerStoreLayoutSectionButton(
                title: button['title'] as String,
                sectionId: button['section_id'] as String,
              )
        ],
      ));
    } else if (block['layout']['name'] == 'separator') {
      list.add(VkStickerStoreLayoutSeparator());
    } else {
      iLog('Unknown block type: ${jsonEncode(block)}');
    }
  }

  return _BackgroundComputationResultVkStoreLayout(list, nextFrom);
}

class VkStickerStoreSection {
  VkStickerStoreSection({
    required this.title,
    required this.id,
    required this.account,
  });

  final String title;
  final String id;
  final Account account;

  Stream<VkStickerStoreLayout> _getContent() async* {
    String? nextFrom;

    do {
      final data = (await account.vk.call(
        'catalog.getSection',
        <String, String>{
          'section_id': id,
          'extended': '1',
          if (nextFrom != null) 'start_from': nextFrom,
        },
        isTraced: false,
        lazyInterpretation: true,
      ));
      data.allowInterpretation!(false);

      final _BackgroundComputationResultVkStoreLayout res =
          await compute(_decodeRequest, await data.response.toList());

      if (res.list.isEmpty) break;

      yield* Stream.fromIterable(res.list);
      nextFrom = res.nextFrom;
    } while (nextFrom != null);
  }

  VkStickerStoreContent? _contentCache;

  Future<VkStickerStoreContent> getContent() async {
    _contentCache ??=
        VkStickerStoreContent(layout: await _getContent().toList());
    return _contentCache!;
  }
}

class VkStickerStoreContent {
  final List<VkStickerStoreLayout> layout;

  const VkStickerStoreContent({required this.layout});
}

abstract class VkStickerStoreLayout {}

class VkStickerStoreLayoutHeader implements VkStickerStoreLayout {
  final String title;
  final List<VkStickerStoreLayoutSectionButton> buttons;

  const VkStickerStoreLayoutHeader({
    required this.title,
    required this.buttons,
  });
}

class VkStickerStoreLayoutSectionButton {
  final String title;
  final String sectionId;

  const VkStickerStoreLayoutSectionButton({
    required this.title,
    required this.sectionId,
  });
}

class VkStickerStoreLayoutSeparator implements VkStickerStoreLayout {}

enum VkStickerStoreLayoutPackListType {
  slider,
  list,
}

class VkStickerStoreLayoutPackList implements VkStickerStoreLayout {
  final List<VkStickerStorePack> packs;
  final VkStickerStoreLayoutPackListType type;

  const VkStickerStoreLayoutPackList({
    required this.packs,
    required this.type,
  });
}

class VkStickerStoreStickerAndPack {
  final VkStickerStoreSticker sticker;
  final VkStickerStorePack? pack;

  const VkStickerStoreStickerAndPack({
    required this.sticker,
    required this.pack,
  });
}

class VkStickerStoreLayoutStickersList implements VkStickerStoreLayout {
  final List<VkStickerStoreStickerAndPack> stickers;

  const VkStickerStoreLayoutStickersList({
    required this.stickers,
  });
}

class VkStickerStorePack {
  final int id;
  final String domain;
  final String title;
  final String description;
  final String author;
  final String image;
  final List<VkStickerStoreStyle> styles;

  const VkStickerStorePack({
    required this.id,
    required this.domain,
    required this.title,
    required this.description,
    required this.author,
    required this.image,
    required this.styles,
  });

  factory VkStickerStorePack.fromJson(Map<String, dynamic> json) {
    final hasAnimation = json['product']['has_animation'] as bool? ?? false;
    return VkStickerStorePack(
      id: json['product']['id'] as int,
      domain: json['product']['url'] as String,
      title: json['product']['title'] as String,
      description: json['description'] as String,
      author: json['author'] as String,
      image: json['product']['icon'][1]['url'] as String,
      styles: [
        VkStickerStoreStyle(
          id: json['product']['id'] as int,
          domain: json['product']['url'] as String,
          title: json['product']['title'] as String,
          image: json['product']['icon'][1]['url'] as String,
          isAnimated: hasAnimation,
          stickers: [
            for (final sticker in json['product']['stickers'] as List<dynamic>)
              VkStickerStoreSticker(
                id: sticker['sticker_id'] as int,
                thumbnail:
                    sticker['images_with_background'][1]['url'] as String,
                image: (hasAnimation
                    ? sticker['animation_url'] as String
                    : sticker['images'][3]['url'] as String),
              ),
          ],
        ),
      ],
    );
  }
}

class VkStickerStoreStyle {
  final int id;
  final String domain;
  final bool isAnimated;
  final String title;
  final String image;
  final List<VkStickerStoreSticker>? stickers;

  const VkStickerStoreStyle({
    required this.id,
    required this.domain,
    required this.isAnimated,
    required this.title,
    required this.image,
    this.stickers,
  });
}

class VkStickerStoreSticker {
  final int id;
  final String thumbnail;
  final String image;
  final List<String>? suggestions;

  const VkStickerStoreSticker({
    required this.id,
    required this.thumbnail,
    required this.image,
    this.suggestions,
  });
}
