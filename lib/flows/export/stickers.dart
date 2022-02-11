import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sticker_import/export/controller.dart';
import 'package:sticker_import/flows/export/emoji_chooser.dart';
import 'package:sticker_import/flows/export/finish.dart';
import 'package:sticker_import/generated/l10n.dart';

class StickerChooserRoute extends StatefulWidget {
  const StickerChooserRoute({Key? key, required this.controller})
      : super(key: key);

  final ExportController controller;

  @override
  _StickerChooserRouteState createState() => _StickerChooserRouteState();
}

class _StickerChooserRouteState extends State<StickerChooserRoute> {
  final enabled = <bool>[];
  final emoji = <String>[];

  @override
  void initState() {
    for (final file in widget.controller.result!) {
      imageCache?.evict(FileImage(File(file)));
    }

    enabled.addAll(List.filled(widget.controller.result!.length, true));
    emoji.addAll(List.filled(widget.controller.result!.length, ''));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).prepare_pack),
        actions: [
          IconButton(
            tooltip: S.of(context).select_all,
            onPressed: () {
              final isEverythingSelected = enabled.every((element) => element);

              setState(() {
                enabled.clear();
                enabled.addAll(
                  List.filled(
                    widget.controller.result!.length,
                    !isEverythingSelected,
                  ),
                );
              });
            },
            icon: Icon(Icons.select_all_rounded),
          ),
          IconButton(
            tooltip: S.of(context).done,
            onPressed: () {
              final pth = <String>[];
              final emj = <String>[];

              widget.controller.result!.asMap().forEach((index, path) {
                if (!enabled[index]) return;

                pth.add(path);
                if (emoji[index].isNotEmpty) {
                  emj.add(emoji[index]);
                } else {
                  emj.add('#️⃣');
                }
              });

              Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) {
                    return ExportFinishRoute(
                      paths: pth,
                      emojis: emj,
                      isAnimated: widget.controller.isAnimated,
                    );
                  },
                ),
              );
            },
            icon: Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: ListView(
        children: [
          Card(
            margin: EdgeInsets.all(15.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(10.0),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.info_rounded),
              ),
              title: Text(S.of(context).customize_your_pack),
              subtitle: Text(S.of(context).customize_your_pack_info +
                  (widget.controller.isAnimated
                      ? '\n\n' + S.of(context).not_all_animated
                      : '')),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.controller.result!.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            itemBuilder: (context, n) {
              return AnimatedOpacity(
                opacity: (enabled[n] ? 1 : .6),
                duration: Duration(milliseconds: 250),
                child: Semantics(
                  checked: enabled[n],
                  hint: S.of(context).enable_sticker,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        enabled[n] = !enabled[n];
                      });
                    },
                    child: Stack(
                      children: [
                        if (widget.controller.isAnimated)
                          Image.file(File(widget.controller.previews![n])),
                        if (!widget.controller.isAnimated)
                          Image.file(File(widget.controller.result![n])),
                        Checkbox(
                            value: enabled[n],
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onChanged: (v) {
                              if (v == null) return;
                              setState(() {
                                enabled[n] = v;
                              });
                            }),
                        if (enabled[n])
                          Align(
                            alignment: Alignment.bottomRight,
                            child: CircleAvatar(
                              child: IconButton(
                                tooltip: S.of(context).choose_emoji,
                                onPressed: () async {
                                  final m =
                                      await Navigator.of(context).push<String>(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return EmojiPickerScreen();
                                      },
                                    ),
                                  );

                                  setState(() {
                                    emoji[n] = m ?? '';
                                  });
                                },
                                icon: (emoji[n].isEmpty
                                    ? Icon(Icons.face_rounded)
                                    : Text(
                                        emoji[n],
                                        style: TextStyle(
                                          fontSize: 24,
                                          height: 1.1,
                                        ),
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.center,
                                      )),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
