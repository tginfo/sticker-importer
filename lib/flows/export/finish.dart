import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sticker_import/components/ui/body_padding.dart';
import 'package:sticker_import/components/ui/large_text.dart';
import 'package:sticker_import/components/ui/logo.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/settings/settings.dart';
import 'package:url_launcher/url_launcher.dart';

class ExportFinishRoute extends StatefulWidget {
  ExportFinishRoute({
    Key? key,
    required this.paths,
    required this.emojis,
    required this.isAnimated,
  }) : super(key: key);

  final List<String> paths;
  final List<String> emojis;
  final bool isAnimated;

  @override
  _ExportFinishRouteState createState() => _ExportFinishRouteState();
}

class _ExportFinishRouteState extends State<ExportFinishRoute> {
  @override
  void initState() {
    super.initState();

    SettingsStorage.intentChannel.invokeMethod(
      'sendDrKLOIntent',
      {
        'paths': widget.paths,
        'emoji': widget.emojis,
        'isAnimated': widget.isAnimated,
        'package': SettingsStorage.packageInfo!.packageName,
      },
    ).onError((e, stackTrace) {
      if (e is PlatformException &&
          e.message != null &&
          e.message!.contains('No Activity found to handle Intent')) {
        noTelegramAppAlert(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    LogoAsset(),
                  ],
                ),
                LargeText(S.of(context).done_exc),
                BodyPadding(
                  child: Text(
                    S.of(context).done_exc_block1,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                BodyPadding(
                  child: Text(
                    S.of(context).done_exc_block2,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                BodyPadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          launch('tg://resolve?domain=tginfo');
                        },
                        icon: Icon(Icons.arrow_forward_rounded),
                        label: Text(S.of(context).follow_tginfo),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          launch('https://donate.tginfo.me');
                        },
                        icon: Icon(Icons.volunteer_activism_rounded),
                        label: Text(S.of(context).donate),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> noTelegramAppAlert(BuildContext context) async {
  var alert = AlertDialog(
    title: Text(S.of(context).error),
    content: Text(S.of(context).not_installed),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(S.of(context).ok),
      ),
    ],
  );

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
