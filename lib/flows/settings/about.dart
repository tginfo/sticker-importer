import 'package:flutter/material.dart';
import 'package:sticker_import/components/icons/custom_icons_icons.dart';
import 'package:sticker_import/components/ui/body_padding.dart';
import 'package:sticker_import/components/ui/large_text.dart';
import 'package:sticker_import/components/ui/logo.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/settings/settings.dart';
import 'package:sticker_import/utils/debugging.dart';
import 'package:url_launcher/url_launcher.dart';

import 'licenses.dart';

class AboutRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).about_program),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  LogoAsset(),
                ],
              ),
              LargeText(S.of(context).about_program),
              BodyPadding(
                child: Text(
                  '${S.of(context).version} ${SettingsStorage.packageInfo?.version ?? ''}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              BodyPadding(
                child: Column(children: [
                  ListTile(
                    leading: Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.campaign_rounded,
                        color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Theme.of(context).primaryColor),
                      ),
                    ),
                    title: Text(S.of(context).telegram_info),
                    subtitle: Text(S.of(context).telegram_info_desc),
                    onTap: () {
                      launchUrl(Uri.tryParse(S.of(context).tginfo_link) ??
                          Uri.parse('https://t.me/tginfo'));
                    },
                  ),
                  ListTile(
                    leading: Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.person_rounded,
                        color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Theme.of(context).primaryColor),
                      ),
                    ),
                    title: Text(S.of(context).sominemo),
                    subtitle: Text(S.of(context).sominemo_desc),
                  ),
                  ListTile(
                    leading: Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.person_rounded,
                        color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Theme.of(context).primaryColor),
                      ),
                    ),
                    title: Text(S.of(context).antonio_marreti),
                    subtitle: Text(S.of(context).antonio_marreti_desc),
                  ),
                  ListTile(
                    leading: Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        CustomIcons.github,
                        color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Theme.of(context).primaryColor),
                      ),
                    ),
                    title: Text(S.of(context).github),
                    subtitle: Text(S.of(context).source_code),
                    onTap: () {
                      launchUrl(Uri.parse(
                          'https://github.com/tginfo/sticker-importer'));
                    },
                  ),
                  Divider(),
                  StatefulBuilder(builder: (BuildContext context, setState) {
                    return SwitchListTile(
                        title: Text(S.of(context).detailed_logging),
                        subtitle: Text(S.of(context).detailed_logging_info),
                        secondary: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.data_exploration_rounded,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Theme.of(context).primaryColor),
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
                    leading: Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.bug_report_rounded,
                        color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Theme.of(context).primaryColor),
                      ),
                    ),
                    title: Text(S.of(context).save_logs),
                    onTap: () async {
                      try {
                        final r = await saveLogs();

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
                  Divider(),
                  ListTile(
                    leading: Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.receipt_long_rounded,
                        color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Theme.of(context).primaryColor),
                      ),
                    ),
                    title: Text(S.of(context).licenses),
                    subtitle: Text(S.of(context).licenses_desc),
                    onTap: () {
                      Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) {
                            return LicensesRoute();
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
    );
  }
}
