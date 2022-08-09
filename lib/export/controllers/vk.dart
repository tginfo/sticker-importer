import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:enough_convert/enough_convert.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sticker_import/export/controllers/model.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/account.dart';
import 'package:sticker_import/utils/debugging.dart';
import 'package:vkget/vkget.dart';

class VkExportController extends ExportController {
  VkExportController({
    required this.account,
    required this.uri,
    required this.isWithBorder,
    required this.context,
    required super.onStyleChooser,
    required super.onShouldUseAnimated,
  });

  int? id;
  final bool isWithBorder;
  final Uri uri;
  final BuildContext context;

  @override
  bool isAnimated = false;

  @override
  int get count {
    return stickerTarget?.stickerIds.length ?? 0;
  }

  @override
  List<String> previews = [];

  @override
  List<String> result = [];

  @override
  int processed = 0;

  Map<String, dynamic>? info;
  StickerStyle? stickerTarget;
  final Account account;

  final StreamController<Function> _notifier = StreamController();
  Stream<Function>? _broadcast;
  @override
  Stream<Function> get notifier => _broadcast!;

  void _setState(Function f) {
    _notifier.add(f);
  }

  bool _isInited = false;

  @override
  void init() {
    _broadcast ??= _notifier.stream.asBroadcastStream();
    warmup().onError((error, stackTrace) {
      _setState(() {
        state = ExportControllerState.error;
        errorDetails = stackTrace.toString();
      });
      if (error != null) throw error;
    });
  }

  @override
  Future<void> warmup() async {
    final locale = Localizations.localeOf(context).languageCode;

    // If stopped
    if (!_isInited || state == ExportControllerState.stopped) {
      // Start warm-up
      _setState(() {
        state = ExportControllerState.warmingUp;
      });

      await account.fire();

      try {
        id = await stickerUrlToId(account.vk, uri);
      } catch (e) {
        if (e == HttpStatus.tooManyRequests) {
          _setState(() {
            state = ExportControllerState.error;
            errorDetails = S.of(context).vk_error_429;
          });
          return;
        }

        rethrow;
      }

      iLog('Pack ID: $id');

      if (id == null) {
        _setState(() {
          errorDetails =
              'Pack ID is not found for $uri. Check if your link is correct.';
          state = ExportControllerState.error;
        });
        return;
      }

      info = await getStickerJson(locale, account.vk, id!);

      final List<StickerStyle> stickerStyles = [];

      for (final style in info!['payload'][1][0]['products'] as List<dynamic>) {
        final img = await account.vk.fetch(
          Uri.parse(
            'https://vk.com/sticker/1-${style['sticker_ids'][0]}-128',
          ),
        );

        final imgRawList = <int>[];
        await for (final b in img) {
          imgRawList.addAll(b);
        }

        if (state == ExportControllerState.stopped) {
          return;
        }

        stickerStyles.add(StickerStyle(
          title: style['title'] as String,
          image: Image.memory(Uint8List.fromList(imgRawList)),
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

      _isInited = true;

      // ignore: unawaited_futures
      worker().onError((error, stackTrace) {
        _setState(() {
          state = ExportControllerState.error;
          errorDetails = stackTrace.toString();
        });
        if (error != null) throw error;
      });
    }
  }

  @override
  Future<void> worker() async {
    _setState(() {
      state = ExportControllerState.working;
    });

    final directory = (await getTemporaryDirectory()).path;
    final files = <String>[];
    GZipCodec? gzip;

    if (isAnimated) {
      gzip = GZipCodec();
    }

    for (final stickerId in stickerTarget!.stickerIds) {
      if (state == ExportControllerState.stopped) return;

      final targetFile = File(isAnimated
          ? '$directory/stickers/$id/$stickerId.tgs'
          : '$directory/stickers/$id/$stickerId.png');
      if (await targetFile.exists()) await targetFile.delete();
      await targetFile.create(recursive: true);

      HttpClientResponse i;

      if (isAnimated) {
        final tempFile = File('$directory/stickers/$id/$stickerId.json');
        final tempFileStream = tempFile.openWrite();

        if (await tempFile.exists()) await tempFile.delete();
        await tempFile.create(recursive: true);

        i = await account.vk.fetch(
          Uri.parse('https://vk.com/sticker/$stickerId/animation.json'),
        );

        final preview = await account.vk.fetch(
          Uri.parse('https://vk.com/sticker/1-$stickerId-128'),
        );
        final previewFile =
            File('$directory/stickers/$id/previews/$stickerId.png');
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
              'https://vk.com/sticker/1-$stickerId-512${isWithBorder ? 'b' : ''}'),
        );

        await i.listen(targetFileStream.add).asFuture<List<int>?>();
        await targetFileStream.flush();
        await targetFileStream.close();
      }

      files.add(targetFile.path);

      _setState(() {
        processed++;
      });
    }

    if (state == ExportControllerState.stopped) return;

    result = files;

    _setState(() {
      state = ExportControllerState.done;
    });
  }

  @override
  void stop() {
    _setState(() {
      state = ExportControllerState.stopped;
    });
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
    return throw HttpStatus.tooManyRequests;
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
