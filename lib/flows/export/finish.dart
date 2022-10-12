import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sticker_import/components/icons/custom_icons_icons.dart';
import 'package:sticker_import/components/ui/large_text.dart';
import 'package:sticker_import/components/ui/logo.dart';
import 'package:sticker_import/flows/user/store/open_store.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/native/method_channels.dart';
import 'package:sticker_import/utils/debugging.dart';
import 'package:sticker_import/utils/launch_telegram.dart';

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
    triggerImport();
  }

  void triggerImport() {
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  color: Theme.of(context).indicatorColor,
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  },
                ),
              ],
            ),
          ),
        ),
        body: ListTileTheme.merge(
          minLeadingWidth: 40,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          iconColor: Theme.of(context).indicatorColor,
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  LogoAsset(),
                                ],
                              ),
                              LargeText(S.of(context).import_is_done),
                              ListTile(
                                title: Text(S.of(context).retry),
                                leading: const Icon(Icons.rotate_right_rounded),
                                onTap: () {
                                  triggerImport();
                                },
                              ),
                              ListTile(
                                title: Text(S.of(context).customize),
                                leading: const Icon(Icons.select_all_rounded),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                title: Text(S.of(context).go_to_sticker_store),
                                leading: const Icon(Icons.storefront_rounded),
                                onTap: () async {
                                  await Navigator.of(context).maybePop();
                                  // ignore: use_build_context_synchronously, unawaited_futures
                                  openStickerStore(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.1),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              elevation: 2,
                              clipBehavior: Clip.antiAlias,
                              child: ListTile(
                                onTap: () {
                                  launchChannel(context);
                                },
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                minLeadingWidth: 36,
                                leading: Text(
                                  '👀',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                title: RichText(
                                  text: TextSpan(
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    text: S
                                        .of(context)
                                        .subscribe_tg_channel_up_sell_part_1,
                                    children: [
                                      TextSpan(
                                        text: '@${S.of(context).tginfo_tag}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .switchTheme
                                              .thumbColor!
                                              .resolve(
                                                  {MaterialState.selected}),
                                          inherit: true,
                                        ),
                                      ),
                                      TextSpan(
                                        text: S
                                            .of(context)
                                            .subscribe_tg_channel_up_sell_part_2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(S.of(context).donate),
                              leading: const Icon(Icons.local_cafe_rounded),
                              onTap: () {
                                launchDonate();
                              },
                            ),
                            ListTile(
                              title: Text(S.of(context).source_code_on_github),
                              leading: const Icon(CustomIcons.github),
                              onTap: () {
                                launchGitHub();
                              },
                            ),
                            ListTile(
                              title: Text(S.of(context).feedback),
                              leading: const Icon(Icons.feedback_rounded),
                              onTap: () {
                                launchFeedback(context);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
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
