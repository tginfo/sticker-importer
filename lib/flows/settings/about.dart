import 'package:flutter/material.dart';
import 'package:sticker_import/components/icons/custom_icons_icons.dart';
import 'package:sticker_import/components/ui/body_padding.dart';
import 'package:sticker_import/components/ui/large_text.dart';
import 'package:sticker_import/components/ui/logo.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/settings/settings.dart';
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
                  S.of(context).version +
                      ' ' +
                      (SettingsStorage.packageInfo?.version ?? ''),
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
                      launch(S.of(context).tginfo_link);
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
                      launch('https://github.com/tginfo/sticker-importer');
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
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
