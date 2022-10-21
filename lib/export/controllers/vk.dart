import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sticker_import/export/controllers/model.dart';
import 'package:sticker_import/services/connection/account.dart';

import 'common/mixins.dart';

class VkExportController extends ExportController with VkStickerStoreUrlGet {
  VkExportController({
    required this.account,
    required this.uri,
    required this.isWithBorder,
    required this.context,
    required super.onStyleChooser,
    required super.onShouldUseAnimated,
  });

  @override
  int? id;
  final bool isWithBorder;
  @override
  final Uri uri;
  @override
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
  final emojiSuggestions = null;

  @override
  int processed = 0;

  @override
  Map<String, dynamic>? info;

  @override
  StickerStyle? stickerTarget;

  @override
  final Account account;

  @override
  bool isInited = false;

  @override
  Future<void> warmup() async {
    await getByUrlWarmup();
    return super.warmup();
  }

  @override
  Future<void> worker() async {
    setState(() {
      state = ExportControllerState.working;
    });

    final directory = (await getTemporaryDirectory()).path;
    final files = <String>[];
    GZipCodec? gzip;

    if (isAnimated) {
      gzip = GZipCodec(level: ZLibOption.maxLevel);
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
        final tempFileStream = await tempFile.open(mode: FileMode.write);

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

        i = await account.vk.fetch(
          Uri.parse('https://vk.com/sticker/$stickerId/animation.json'),
        );

        await tempFileStream
            .writeFrom(await i.expand((element) => element).toList());
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

  @override
  void stop() {
    setState(() {
      state = ExportControllerState.stopped;
    });
  }
}
