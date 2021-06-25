import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/account.dart';
import 'package:sticker_import/utils/sticker_url_to_id.dart';

enum ExportControllerState {
  stopped,
  warmingUp,
  working,
  paused,
  retrying,
  error,
  done,
}

class ExportController {
  ExportController({
    required this.account,
    required this.uri,
    required this.isWithBorder,
    required this.context,
  });

  int? id;
  int processed = 0;
  final bool isWithBorder;
  final Uri uri;
  final BuildContext context;
  String? errorDefails;
  List<String>? result;
  List<String>? previews;
  bool isAnimated = false;

  List<int> get stickerIds {
    if (info == null) return [];
    return List<int>.from(info!['payload'][1][0]['products'][0]['sticker_ids']);
  }

  Map<String, dynamic>? info;
  final Account account;

  final StreamController<Function> _notifier = StreamController();
  Stream<Function>? _broadcast;
  Stream<Function> get notifier => _broadcast!;

  void _setState(f) {
    _notifier.add(f);
  }

  bool _isInited = false;

  ExportControllerState state = ExportControllerState.stopped;

  void init() {
    _broadcast ??= _notifier.stream.asBroadcastStream();
    warmup().onError((error, stackTrace) {
      _setState(() {
        state = ExportControllerState.error;
        errorDefails = stackTrace.toString();
      });
    });
  }

  Future<void> warmup() async {
    // If stopped
    if (!_isInited || state == ExportControllerState.stopped) {
      // Start warm-up
      _setState(() {
        state = ExportControllerState.warmingUp;
      });

      await account.fire();

      id = await stickerUrlToId(account.vk, uri);
      print('Pack ID: $id');

      if (id == null) {
        _setState(() {
          errorDefails = 'Pack ID is not found for ' +
              uri.toString() +
              '. Check if your link is correct.';
          state = ExportControllerState.error;
        });
        return;
      }

      info = await getStickerJson(account.vk, id!);
      print(info);

      if (info!['payload'][1][0]['products'][0]['is_animated'] as bool &&
          await shouldUseAnimated(context)) {
        isAnimated = true;
        previews = [];
      }

      _isInited = true;

      // ignore: unawaited_futures
      _worker().onError((error, stackTrace) {
        _setState(() {
          state = ExportControllerState.error;
          errorDefails = stackTrace.toString();
        });
      });
    }
  }

  Future _worker() async {
    _setState(() {
      state = ExportControllerState.working;
    });

    final directory = (await getTemporaryDirectory()).path;
    final files = <String>[];
    GZipCodec? gzip;

    if (isAnimated) {
      gzip = GZipCodec();
    }

    for (final stickerId in stickerIds) {
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
        await preview.listen(previewFileStream.add).asFuture();
        await previewFileStream.flush();
        await previewFileStream.close();

        previews!.add(previewFile.path);

        await i.listen(tempFileStream.add).asFuture();
        await tempFileStream.flush();
        await tempFileStream.close();

        await targetFile.writeAsBytes(
          gzip!.encode(List.from(await tempFile.readAsBytes())),
        );

        await tempFile.delete();
      } else {
        final targetFileStream = targetFile.openWrite();

        i = await account.vk.fetch(
          Uri.parse('https://vk.com/sticker/1-$stickerId-512' +
              (isWithBorder ? 'b' : '')),
        );

        await i.listen(targetFileStream.add).asFuture();
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

  void stop() {
    _setState(() {
      state = ExportControllerState.stopped;
    });
  }
}

Future<bool> shouldUseAnimated(BuildContext context) async {
  var alert = AlertDialog(
    title: Text(S.of(context).animated_pack),
    content: Text(S.of(context).animated_pack_info +
        '\n\n' +
        S.of(context).not_all_animated),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        child: Text(S.of(context).still),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop(true);
        },
        child: Text(S.of(context).animated),
      )
    ],
  );

  // show the dialog
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      ) ??
      true;
}
