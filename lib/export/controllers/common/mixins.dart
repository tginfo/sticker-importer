import 'dart:convert';
import 'dart:io';

import 'package:enough_convert/windows.dart';
import 'package:flutter/material.dart';
import 'package:sticker_import/components/flutter/vk_image.dart';
import 'package:sticker_import/export/controllers/model.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/account.dart';
import 'package:sticker_import/utils/debugging.dart';
import 'package:vkget/vkget.dart';

mixin VkStickerStoreUrlGet on ExportController {
  Map<String, dynamic>? get info;
  set info(Map<String, dynamic>? i);

  StickerStyle? get stickerTarget;
  set stickerTarget(StickerStyle? s);

  Uri get uri;
  BuildContext get context;
  Account get account;

  int? get id;
  set id(int? i);

  bool get isInited;
  set isInited(bool i);

  @override
  List<String> get previews;
  set previews(List<String> p);

  @override
  bool get isAnimated;
  set isAnimated(bool r);

  Future<void> getByUrlWarmup() async {
    final locale = Localizations.localeOf(context).languageCode;

    // If stopped
    if (!isInited || state == ExportControllerState.stopped) {
      // Start warm-up
      setState(() {
        state = ExportControllerState.warmingUp;
      });

      await account.fire(language: S.of(context).code);

      try {
        if (uri.queryParameters.containsKey('stickers_id')) {
          id = int.tryParse(uri.queryParameters['stickers_id']!);
        }

        id ??= await stickerUrlToId(account.vk, uri);
      } catch (e) {
        if (e == HttpStatus.tooManyRequests) {
          setState(() {
            state = ExportControllerState.error;
            errorDetails = S.of(context).vk_error_429;
          });
          return;
        }

        rethrow;
      }

      iLog('Pack ID: $id');

      if (id == null) {
        setState(() {
          errorDetails = S.of(context).pack_not_found(uri.toString());
          state = ExportControllerState.error;
        });
        return;
      }

      info = await getStickerJson(locale, account.vk, id!);

      final List<StickerStyle> stickerStyles = [];

      for (final style in info!['payload'][1][0]['products'] as List<dynamic>) {
        final image = VKGetImage.vk(
          'https://vk.com/sticker/1-${style['sticker_ids'][0]}-128',
          account.vk,
        );

        // ignore: use_build_context_synchronously
        await precacheImage(image.image, context);

        if (state == ExportControllerState.stopped) {
          return;
        }

        stickerStyles.add(StickerStyle(
          title: style['title'] as String,
          image: image,
          id: style['id'] as int,
          isAnimated: style['is_animated'] as bool,
          stickerIds: (style['sticker_ids'] as List).cast<int>(),
        ));
      }

      if (stickerStyles.length > 1) {
        stickerTarget = await onStyleChooser(stickerStyles);
      } else {
        stickerTarget = stickerStyles[0];
      }

      if (state == ExportControllerState.stopped) {
        return;
      }

      if (stickerTarget!.isAnimated && await onShouldUseAnimated()) {
        isAnimated = true;
        previews = [];
      }

      isInited = true;
    }
  }
}

Future<int?> stickerUrlToId(VKGet client, Uri url) async {
  final req = await client.fetch(
    url,
    overrideUserAgent:
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36',
  );
  final html =
      await const Windows1251Codec(allowInvalid: false).decodeStream(req);
  iLog(html, large: true);

  final res =
      RegExp(r'Emoji.previewSticker\((\d+)\)').firstMatch(html)?.group(1);
  iLog(res);

  if (res != null) return int.tryParse(res);

  if (html.contains('Error 429')) {
    throw HttpStatus.tooManyRequests;
  }

  return null;
}

Future<Map<String, dynamic>> getStickerJson(
    String locale, VKGet client, int id) async {
  final req = await client.fetch(
      Uri.parse('https://vk.com/stickers.php?act=preview_products_order'),
      method: 'POST',
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Accept-Language': locale,
      },
      bodyFields: <String, String>{
        'act': 'preview_products_order',
        'al': '1',
        'cart': '{"items":[{"product_id":$id,"amount":1}],"recipient_ids":[]}',
        'with_suggested_recipients': '0',
      });
  final text =
      await const Windows1251Codec(allowInvalid: false).decodeStream(req);
  iLog(text, large: true);

  return jsonDecode(text) as Map<String, dynamic>;
}
