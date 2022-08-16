import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sticker_import/components/ui/body_padding.dart';
import 'package:sticker_import/components/ui/large_text.dart';
import 'package:sticker_import/components/ui/logo.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/native/method_channels.dart';
import 'package:sticker_import/utils/debugging.dart';
import 'package:url_launcher/url_launcher.dart';

class ExportFinishRoute extends StatefulWidget {
  const ExportFinishRoute({
    Key? key,
    required this.paths,
    required this.emojis,
    required this.isAnimated,
  }) : super(key: key);

  final List<String> paths;
  final List<String> emojis;
  final bool isAnimated;

  @override
  ExportFinishRouteState createState() => ExportFinishRouteState();
}

class ExportFinishRouteState extends State<ExportFinishRoute> {
  @override
  void initState() {
    super.initState();

    MethodChannelStore.intentChannel.invokeMethod<dynamic>(
      'sendDrKLOIntent',
      <String, dynamic>{
        'paths': widget.paths,
        'emoji': widget.emojis,
        'isAnimated': widget.isAnimated,
        'package': MethodChannelStore.packageInfo!.packageName,
      },
    ).onError((e, stackTrace) {
      iLog(e);
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
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
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
                          launchUrl(
                            Uri.parse('tg://resolve?domain=tginfo'),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: Text(S.of(context).follow_tginfo),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          launchUrl(
                            Uri.parse('https://donate.tginfo.me'),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        icon: const Icon(Icons.volunteer_activism_rounded),
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
  final alert = AlertDialog(
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

  await showDialog<dynamic>(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
