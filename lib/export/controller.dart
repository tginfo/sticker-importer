import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/account.dart';
import 'package:sticker_import/utils/sticker_url_to_id.dart';
import 'package:sticker_import/utils/map.dart';

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
  String? errorDetails;
  List<String>? result;
  List<String>? previews;
  bool isAnimated = false;

  List<int> get stickerIds {
    if (info == null) return [];
    return List<int>.from(stickerTarget!['sticker_ids'] as Iterable<dynamic>);
  }

  Map<String, dynamic>? info;
  Map<String, dynamic>? stickerTarget;
  final Account account;

  final StreamController<Function> _notifier = StreamController();
  Stream<Function>? _broadcast;
  Stream<Function> get notifier => _broadcast!;

  void _setState(Function f) {
    _notifier.add(f);
  }

  bool _isInited = false;

  ExportControllerState state = ExportControllerState.stopped;

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
          errorDetails = 'Pack ID is not found for ' +
              uri.toString() +
              '. Check if your link is correct.';
          state = ExportControllerState.error;
        });
        return;
      }

      info = await getStickerJson(context, account.vk, id!);

      if ((info!['payload'][1][0]['products'] as List<dynamic>).length > 1) {
        stickerTarget = await chooseYourFighter(
          context,
          List<Map<String, dynamic>>.from(
              info!['payload'][1][0]['products'] as List<dynamic>),
          this,
        );
      } else {
        stickerTarget =
            info!['payload'][1][0]['products'][0] as Map<String, dynamic>;
      }

      if (state == ExportControllerState.stopped) {
        return;
      }

      if (stickerTarget!['is_animated'] as bool &&
          await shouldUseAnimated(context)) {
        isAnimated = true;
        previews = [];
      }

      _isInited = true;

      // ignore: unawaited_futures
      _worker().onError((error, stackTrace) {
        _setState(() {
          state = ExportControllerState.error;
          errorDetails = stackTrace.toString();
        });
        if (error != null) throw error;
      });
    }
  }

  Future<void> _worker() async {
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
        await preview.listen(previewFileStream.add).asFuture<List<int>?>();
        await previewFileStream.flush();
        await previewFileStream.close();

        previews!.add(previewFile.path);

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
          Uri.parse('https://vk.com/sticker/1-$stickerId-512' +
              (isWithBorder ? 'b' : '')),
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

  void stop() {
    _setState(() {
      state = ExportControllerState.stopped;
    });
  }
}

Future<bool> shouldUseAnimated(BuildContext context) async {
  final alert = AlertDialog(
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

Future<Map<String, dynamic>> chooseYourFighter(
  BuildContext context,
  List<Map<String, dynamic>> packs,
  ExportController controller,
) async {
  var index = 0;

  void changer(int ind) {
    index = ind;
  }

  final images = <Image>[];
  for (final style in packs) {
    final i = await controller.account.vk.fetch(
        Uri.parse('https://vk.com/sticker/1-${style['sticker_ids'][0]}-128'));

    final imgRawList = <int>[];
    await for (final b in i) {
      imgRawList.addAll(b);
    }

    if (controller.state == ExportControllerState.stopped) {
      return <String, dynamic>{};
    }

    final imgRaw = Uint8List.fromList(imgRawList);
    images.add(Image.memory(imgRaw));
  }

  final alert = AlertDialog(
    contentPadding: EdgeInsets.only(bottom: 25, left: 25, right: 25),
    content: Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 2,
      ),
      decoration: BoxDecoration(),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25.0,
            ),
            Text(
              S.of(context).sticker_styles,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(S.of(context).sticker_styles_info),
            SizedBox(
              height: 10.0,
            ),
            StickerStyleChooser(
              styles: packs,
              changer: changer,
              images: images,
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(packs[index]);
        },
        child: Text(S.of(context).continue_btn),
      ),
    ],
  );

  // show the dialog
  return (await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      )) ??
      packs[0];
}

class StickerStyleChooser extends StatefulWidget {
  StickerStyleChooser({
    Key? key,
    required this.styles,
    required this.changer,
    required this.images,
  }) : super(key: key);

  final List<Map<String, dynamic>> styles;
  final List<Image> images;
  final void Function(int index) changer;

  @override
  _StickerStyleChooserState createState() => _StickerStyleChooserState();
}

class _StickerStyleChooserState extends State<StickerStyleChooser> {
  int chosen = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.styles.mapIndexed((style, index) {
        return ListTile(
          selected: chosen == index,
          title: Text(style['title'] as String),
          leading: widget.images[index],
          selectedTileColor: Theme.of(context).primaryColor,
          contentPadding: EdgeInsets.all(2.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          onTap: () {
            setState(() {
              chosen = index;
              widget.changer(index);
            });
          },
        );
      }).toList(),
    );
  }
}
