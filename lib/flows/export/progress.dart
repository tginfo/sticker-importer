import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sticker_import/components/ui/body_padding.dart';
import 'package:sticker_import/components/ui/large_text.dart';
import 'package:sticker_import/components/ui/logo.dart';
import 'package:sticker_import/export/controller.dart';
import 'package:sticker_import/flows/export/stickers.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/account.dart';

class ExportProgressFlow extends StatefulWidget {
  ExportProgressFlow({
    Key? key,
    required this.account,
    required this.uri,
    required this.isWithBorder,
  }) : super(key: key);

  final Account account;
  final Uri uri;
  final bool isWithBorder;

  @override
  _ExportProgressFlowState createState() => _ExportProgressFlowState();
}

class _ExportProgressFlowState extends State<ExportProgressFlow> {
  ExportController? controller;
  StreamSubscription? notifier;

  @override
  void initState() {
    controller = ExportController(
      account: widget.account,
      uri: widget.uri,
      isWithBorder: widget.isWithBorder,
      context: context,
    );

    controller!.init();
    notifier = controller!.notifier.listen((event) {
      setState(() {
        event();
      });
    });

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

    if (controller != null && controller!.state == ExportControllerState.done) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return StickerChooserRoute(
              controller: controller!,
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
        var res = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(S.of(context).confirmnation),
              content: Text(S.of(context).stop_export_confirm),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    controller!.stop();
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
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      LogoAsset(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller != null &&
                          (controller!.state == ExportControllerState.working ||
                              controller!.state ==
                                  ExportControllerState.warmingUp))
                        LargeText(S.of(context).export_working),
                      if (controller != null &&
                          (controller!.state == ExportControllerState.paused ||
                              controller!.state ==
                                  ExportControllerState.retrying))
                        LargeText(S.of(context).export_paused),
                      if (controller != null &&
                          controller!.state == ExportControllerState.stopped)
                        LargeText(S.of(context).export_stopped),
                      if (controller != null &&
                          controller!.state == ExportControllerState.error)
                        LargeText(S.of(context).export_error),
                      if (controller != null &&
                          controller!.state == ExportControllerState.done)
                        LargeText(S.of(context).export_done),
                    ],
                  ),
                  if (controller != null &&
                      controller!.state != ExportControllerState.error &&
                      controller!.state != ExportControllerState.done)
                    BodyPadding(
                      child: Text(
                        S.of(context).export_config_info,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                  if (controller != null &&
                      controller!.state == ExportControllerState.error)
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
                          value: (controller == null ||
                                  controller!.state ==
                                      ExportControllerState.warmingUp ||
                                  controller!.info == null
                              ? (controller!.state ==
                                      ExportControllerState.error
                                  ? 0
                                  : null)
                              : controller!.processed /
                                  controller!.stickerIds.length),
                          backgroundColor: Theme.of(context).dividerColor,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).brightness == Brightness.dark
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).primaryColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (controller != null &&
                            ([
                              ExportControllerState.paused,
                              ExportControllerState.stopped,
                              ExportControllerState.working,
                            ].contains(controller!.state)))
                          Text(
                            '${controller!.processed} / ${controller!.stickerIds.length} ' +
                                S
                                    .of(context)
                                    .of_stickers(controller!.stickerIds.length),
                          ),
                        if (controller != null &&
                            ([ExportControllerState.error]
                                .contains(controller!.state)))
                          Text(
                            S.of(context).error,
                            style: TextStyle(
                              color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).primaryColor),
                            ),
                          ),
                        if (controller != null &&
                            ([ExportControllerState.warmingUp]
                                .contains(controller!.state)))
                          Text(S.of(context).warming_up),
                        if (controller != null &&
                            ([ExportControllerState.retrying]
                                .contains(controller!.state)))
                          Text(S.of(context).retrying),
                      ],
                    ),
                  ),
                  if (controller != null)
                    BodyPadding(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (![
                            ExportControllerState.error,
                            ExportControllerState.paused,
                          ].contains(controller!.state))
                            TextButton(
                              onPressed: (controller!.state ==
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
                                  Icon(Icons.stop_rounded),
                                  SizedBox(width: 10),
                                  Text(S.of(context).stop),
                                ],
                              ),
                            ),
                          if ([
                            ExportControllerState.paused,
                          ].contains(controller!.state))
                            TextButton(
                              onPressed: () {
                                controller!.init();
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.play_arrow_rounded),
                                  SizedBox(width: 10),
                                  Text(S.of(context).resume),
                                ],
                              ),
                            ),
                          if ([
                            ExportControllerState.error,
                          ].contains(controller!.state))
                            TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => ListView(
                                    shrinkWrap: true,
                                    children: [
                                      ListTile(
                                        title: Text(S.of(context).error),
                                        subtitle: Text(
                                          controller!.errorDefails ??
                                              'No error detaild available',
                                        ),
                                        trailing: IconButton(
                                          tooltip: S.of(context).copy,
                                          onPressed: () {
                                            Clipboard.setData(
                                              ClipboardData(
                                                  text: controller!
                                                          .errorDefails ??
                                                      ''),
                                            );
                                          },
                                          icon: Icon(Icons.copy_rounded),
                                        ),
                                        contentPadding: EdgeInsets.all(15),
                                      ),
                                    ],
                                  ),
                                );
                                ;
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.info_rounded),
                                  SizedBox(width: 10),
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
