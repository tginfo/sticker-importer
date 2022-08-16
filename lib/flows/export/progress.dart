import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sticker_import/components/ui/body_padding.dart';
import 'package:sticker_import/components/ui/large_text.dart';
import 'package:sticker_import/components/ui/logo.dart';
import 'package:sticker_import/export/controllers/model.dart';
import 'package:sticker_import/flows/export/stickers.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/utils/debugging.dart';
import 'package:sticker_import/utils/map.dart';

class ExportProgressFlow extends StatefulWidget {
  const ExportProgressFlow({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ExportController controller;

  @override
  ExportProgressFlowState createState() => ExportProgressFlowState();
}

class ExportProgressFlowState extends State<ExportProgressFlow> {
  StreamSubscription<Function>? notifier;

  @override
  void initState() {
    try {
      widget.controller.init();
      notifier = widget.controller.notifier.listen((event) {
        setState(() {
          event();
        });
      });
    } catch (e) {
      iLog(e);
      rethrow;
    }

    super.initState();
  }

  @override
  void dispose() {
    if (notifier != null) {
      notifier!.cancel();
    }
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);

    if (widget.controller.state == ExportControllerState.error) {
      iLog(widget.controller.errorDetails ?? 'No error details');
    }

    if (widget.controller.state == ExportControllerState.done) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).push<dynamic>(
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) {
            return StickerChooserRoute(
              controller: widget.controller,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final res = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(S.of(context).confirmation),
              content: Text(S.of(context).stop_export_confirm),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    widget.controller.stop();
                  },
                  child: Text(S.of(context).stop),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(S.of(context).go_back),
                ),
              ],
            );
          },
        );

        if (res == null) return false;
        return res;
      },
      child: Scaffold(
        body: Form(
          child: Center(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      LogoAsset(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if ((widget.controller.state ==
                              ExportControllerState.working ||
                          widget.controller.state ==
                              ExportControllerState.warmingUp))
                        LargeText(S.of(context).export_working),
                      if ((widget.controller.state ==
                              ExportControllerState.paused ||
                          widget.controller.state ==
                              ExportControllerState.retrying))
                        LargeText(S.of(context).export_paused),
                      if (widget.controller.state ==
                          ExportControllerState.stopped)
                        LargeText(S.of(context).export_stopped),
                      if (widget.controller.state ==
                          ExportControllerState.error)
                        LargeText(S.of(context).export_error),
                      if (widget.controller.state == ExportControllerState.done)
                        LargeText(S.of(context).export_done),
                    ],
                  ),
                  if (widget.controller.state != ExportControllerState.error &&
                      widget.controller.state != ExportControllerState.done)
                    BodyPadding(
                      child: Text(
                        S.of(context).export_config_info,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  if (widget.controller.state == ExportControllerState.error)
                    BodyPadding(
                      child: Text(
                        S.of(context).export_error_description,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  BodyPadding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: (() {
                            switch (widget.controller.state) {
                              case ExportControllerState.warmingUp:
                              case ExportControllerState.retrying:
                                return null;
                              default:
                                return widget.controller.count != null &&
                                        widget.controller.count != 0
                                    ? widget.controller.processed /
                                        widget.controller.count!
                                    : 0.0;
                            }
                          })(),
                          backgroundColor: Theme.of(context).dividerColor,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).brightness == Brightness.dark
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).primaryColor),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if ([
                          ExportControllerState.paused,
                          ExportControllerState.stopped,
                          ExportControllerState.working,
                        ].contains(widget.controller.state))
                          Text(
                            '${widget.controller.processed} / ${widget.controller.count} ${S.of(context).of_stickers(widget.controller.count!)}',
                          ),
                        if ([ExportControllerState.error]
                            .contains(widget.controller.state))
                          Text(
                            S.of(context).error,
                            style: TextStyle(
                              color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).primaryColor),
                            ),
                          ),
                        if ([ExportControllerState.warmingUp]
                            .contains(widget.controller.state))
                          Text(S.of(context).warming_up),
                        if ([ExportControllerState.retrying]
                            .contains(widget.controller.state))
                          Text(S.of(context).retrying),
                      ],
                    ),
                  ),
                  BodyPadding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (![
                          ExportControllerState.error,
                          ExportControllerState.paused,
                        ].contains(widget.controller.state))
                          TextButton(
                            onPressed: (widget.controller.state ==
                                    ExportControllerState.done
                                ? null
                                : () {
                                    Navigator.of(context).maybePop();
                                  }),
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) =>
                                    states.contains(MaterialState.disabled)
                                        ? Colors.grey
                                        : null,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.stop_rounded),
                                const SizedBox(width: 10),
                                Text(S.of(context).stop),
                              ],
                            ),
                          ),
                        if ([
                          ExportControllerState.paused,
                        ].contains(widget.controller.state))
                          TextButton(
                            onPressed: () {
                              widget.controller.init();
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.play_arrow_rounded),
                                const SizedBox(width: 10),
                                Text(S.of(context).resume),
                              ],
                            ),
                          ),
                        if ([
                          ExportControllerState.error,
                        ].contains(widget.controller.state))
                          TextButton(
                            onPressed: () {
                              showModalBottomSheet<dynamic>(
                                context: context,
                                builder: (context) => ListView(
                                  shrinkWrap: true,
                                  children: [
                                    ListTile(
                                      title: Text(S.of(context).error),
                                      subtitle: Text(
                                        widget.controller.errorDetails ??
                                            S.of(context).no_error_details,
                                      ),
                                      trailing: IconButton(
                                        tooltip: S.of(context).copy,
                                        onPressed: () {
                                          Clipboard.setData(
                                            ClipboardData(
                                                text: widget.controller
                                                        .errorDetails ??
                                                    ''),
                                          );
                                        },
                                        icon: const Icon(Icons.copy_rounded),
                                      ),
                                      contentPadding: const EdgeInsets.all(15),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.info_rounded),
                                const SizedBox(width: 10),
                                Text(S.of(context).details),
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<StickerStyle> chooseYourFighter(
  BuildContext context,
  List<StickerStyle> packs,
) async {
  var index = 0;

  void changer(int ind) {
    index = ind;
  }

  /* if (!contextWidgetState.mounted) {
    return packs[0];
  } */

  final alert = AlertDialog(
    contentPadding: const EdgeInsets.only(bottom: 25, left: 25, right: 25),
    content: Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height / 2,
      ),
      decoration: const BoxDecoration(),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 25.0,
            ),
            Text(
              S.of(context).sticker_styles,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(S.of(context).sticker_styles_info),
            const SizedBox(
              height: 10.0,
            ),
            StickerStyleChooser(
              styles: packs,
              changer: changer,
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
  return (await showDialog<StickerStyle>(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      )) ??
      packs[0];
}

Future<bool> shouldUseAnimated(BuildContext context) async {
  final alert = AlertDialog(
    title: Text(S.of(context).animated_pack),
    content: Text(
        '${S.of(context).animated_pack_info}\n\n${S.of(context).not_all_animated}'),
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

class StickerStyleChooser extends StatefulWidget {
  const StickerStyleChooser({
    Key? key,
    required this.styles,
    required this.changer,
  }) : super(key: key);

  final List<StickerStyle> styles;
  final void Function(int index) changer;

  @override
  StickerStyleChooserState createState() => StickerStyleChooserState();
}

class StickerStyleChooserState extends State<StickerStyleChooser> {
  int chosen = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.styles.mapIndexed((style, index) {
        return ListTile(
          selected: chosen == index,
          title: Text(style.title),
          leading: style.image,
          selectedTileColor: Theme.of(context).primaryColor,
          contentPadding: const EdgeInsets.all(2.0),
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
