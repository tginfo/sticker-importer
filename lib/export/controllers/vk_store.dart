import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sticker_import/export/controllers/model.dart';
import 'package:sticker_import/generated/emoji_metadata.dart';
import 'package:sticker_import/services/connection/account.dart';
import 'package:sticker_import/services/connection/store.dart';

class VkStoreExportController extends ExportController {
  final Account account;
  final VkStickerStoreStyle style;
  final bool isWithBorder;
  @override
  final bool isAnimated;

  VkStoreExportController({
    required this.account,
    required this.style,
    required this.isWithBorder,
    required this.isAnimated,
  }) : super(
          onShouldUseAnimated: () => Future.value(isAnimated),
          onStyleChooser: (styles) => Future.value(styles[0]),
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

  // TODO: Make code reusable
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
