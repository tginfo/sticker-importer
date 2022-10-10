import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sticker_import/export/controllers/model.dart';
import 'package:sticker_import/generated/emoji_metadata.dart';
import 'package:sticker_import/services/connection/account.dart';
import 'package:sticker_import/services/connection/store.dart';

import 'common/mixins.dart';

class VkStoreExportController extends ExportController {
  final Account account;
  VkStickerStoreStyle style;
  final bool isWithBorder;
  @override
  bool isAnimated;

  VkStoreExportController({
    required this.account,
    required this.style,
    required this.isWithBorder,
    required this.isAnimated,
    Future<bool> Function()? onShouldUseAnimated,
    Future<StickerStyle> Function(List<StickerStyle>)? onStyleChooser,
  }) : super(
          onShouldUseAnimated:
              onShouldUseAnimated ?? () => Future.value(isAnimated),
          onStyleChooser: onStyleChooser ?? (styles) => Future.value(styles[0]),
        );

  @override
  int? get count => style.stickers!.length;

  @override
  int processed = 0;

  @override
  List<String>? result;

  @override
  List<String> previews = [];

  @override
  List<Set<String>>? emojiSuggestions = [];

  @override
  Future<void> worker() async {
    setState(() {
      state = ExportControllerState.working;
    });

    final directory = (await getTemporaryDirectory()).path;
    final files = <String>[];
    GZipCodec? gzip;

    if (isAnimated) {
      gzip = GZipCodec();
    }

    await style.updateKeywords(account);
    if (state == ExportControllerState.stopped) return;

    for (final sticker in style.stickers!) {
      if (state == ExportControllerState.stopped) return;

      final targetFile = File(isAnimated
          ? '$directory/stickers/${style.id}/${sticker.id}.tgs'
          : '$directory/stickers/${style.id}/${sticker.id}.png');
      if (await targetFile.exists()) await targetFile.delete();
      await targetFile.create(recursive: true);

      HttpClientResponse i;

      if (isAnimated) {
        final tempFile =
            File('$directory/stickers/${style.id}/${sticker.id}.json');
        final tempFileStream = tempFile.openWrite();

        if (await tempFile.exists()) await tempFile.delete();
        await tempFile.create(recursive: true);

        i = await account.vk.fetch(
          Uri.parse(sticker.animation!),
        );

        final preview = await account.vk.fetch(
          Uri.parse(sticker.thumbnail),
        );
        final previewFile =
            File('$directory/stickers/${style.id}/previews/${sticker.id}.png');
        await previewFile.create(recursive: true);
        final previewFileStream = previewFile.openWrite();
        await preview.listen(previewFileStream.add).asFuture<List<int>?>();
        await previewFileStream.flush();
        await previewFileStream.close();

        previews.add(previewFile.path);

        await i.listen(tempFileStream.add).asFuture<List<int>?>();
        await tempFileStream.flush();
        await tempFileStream.close();

        await targetFile.writeAsBytes(
          gzip!.encode(List.from(await tempFile.readAsBytes())),
        );

        await tempFile.delete();
      } else {
        final targetFileStream = targetFile.openWrite();

        i = await account.vk.fetch(
          Uri.parse(
            isWithBorder ? sticker.imageWithBorder : sticker.imageWithoutBorder,
          ),
        );

        await i.listen(targetFileStream.add).asFuture<List<int>?>();
        await targetFileStream.flush();
        await targetFileStream.close();
      }

      files.add(targetFile.path);

      final suggestions = <String>{};

      if (sticker.suggestions != null) {
        for (final keyword in sticker.suggestions!) {
          suggestions.addAll(kEmojiAtlas.filterEmoji(keyword));
        }
      }

      emojiSuggestions!.add(suggestions);

      setState(() {
        processed++;
      });
    }

    if (state == ExportControllerState.stopped) return;

    result = files;

    setState(() {
      state = ExportControllerState.done;
    });
  }
}

class VkStoreUrlExportController extends VkStoreExportController
    with VkStickerStoreUrlGet {
  VkStoreUrlExportController({
    required this.uri,
    required this.context,
    required super.account,
    required super.isWithBorder,
    required super.onStyleChooser,
    required super.onShouldUseAnimated,
  }) : super(
            isAnimated: false,
            style: const VkStickerStoreStyle(
              id: 0,
              domain: '',
              isAnimated: false,
              title: '',
              image: '',
            ));

  @override
  final Uri uri;

  @override
  final BuildContext context;

  @override
  int? id;

  @override
  Map<String, dynamic>? info;

  @override
  StickerStyle? stickerTarget;

  @override
  bool isInited = false;

  @override
  Future<void> warmup() async {
    // Handles possible multiple styles and animated stickers
    await getByUrlWarmup();

    style = VkStickerStorePack.fromJson(
      (await account.vk.call(
        'store.getStockItemByProductId',
        <String, String>{
          'product_id': stickerTarget!.id.toString(),
          'type': 'stickers',
          'extended': '1',
        },
      ))
          .asJson()['response'] as Map<String, dynamic>,
    ).styles[0];
    return super.warmup();
  }
}
