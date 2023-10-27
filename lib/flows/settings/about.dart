import 'package:flutter/material.dart';
import 'package:sticker_import/components/icons/custom_icons_icons.dart';
import 'package:sticker_import/components/ui/body_padding.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/native/method_channels.dart';
import 'package:sticker_import/utils/debugging.dart';
import 'package:sticker_import/utils/launch_telegram.dart';

import 'licenses.dart';

class AboutRoute extends StatelessWidget {
  const AboutRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTileTheme.merge(
      minLeadingWidth: 40,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      iconColor: Theme.of(context).indicatorColor,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                BodyPadding(
                  child: Column(children: [
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          CustomIcons.sticker_import,
                        ),
                      ),
                      title: Text(S.of(context).tginfo_sticker_importer),
                      subtitle: Text(
                        MethodChannelStore.packageInfo?.version ?? '',
                      ),
                    ),
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.telegram_rounded,
                        ),
                      ),
                      title: Text(S.of(context).telegram_info),
                      subtitle: Text(S.of(context).telegram_info_desc),
                      onTap: () {
                        launchChannel(context);
                      },
                    ),
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.feedback_rounded,
                        ),
                      ),
                      title: Text(S.of(context).feedback),
                      subtitle: Text(S.of(context).feedback_desc),
                      onTap: () {
                        launchFeedback(context);
                      },
                    ),
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.person_rounded,
                        ),
                      ),
                      title: Text(S.of(context).sominemo),
                      subtitle: Text(S.of(context).sominemo_desc),
                    ),
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          CustomIcons.github,
                        ),
                      ),
                      title: Text(S.of(context).github),
                      subtitle: Text(S.of(context).source_code),
                      onTap: () {
                        launchGitHub();
                      },
                    ),
                    const Divider(),
                    StatefulBuilder(builder: (BuildContext context, setState) {
                      return SwitchListTile(
                          title: Text(S.of(context).detailed_logging),
                          subtitle: Text(S.of(context).detailed_logging_info),
                          secondary: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.data_exploration_rounded,
                            ),
                          ),
                          value: iLogDoDetailedLogging,
                          onChanged: (n) {
                            setState(() {
                              iLogDoDetailedLogging = n;
                            });
                          });
                    }),
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.bug_report_rounded,
                        ),
                      ),
                      title: Text(S.of(context).save_logs),
                      onTap: () async {
                        try {
                          final r = await saveLogs();

                          if (!context.mounted) return;

                          // ignore: unawaited_futures
                          showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(S.of(context).done),
                                content: Text(S.of(context).logs_saved_to(r)),
                                actions: [
                                  TextButton(
                                    child: Text(S.of(context).ok),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (e) {
                          // ignore: unawaited_futures
                          showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(S.of(context).error),
                                content: Text(S.of(context).logs_save_error(e)),
                                actions: [
                                  TextButton(
                                    child: Text(S.of(context).ok),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.receipt_long_rounded,
                        ),
                      ),
                      title: Text(S.of(context).licenses),
                      subtitle: Text(S.of(context).licenses_desc),
                      onTap: () {
                        Navigator.of(context).push<dynamic>(
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) {
                              return const LicensesRoute();
                            },
                          ),
                        );
                      },
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
