import 'package:flutter/material.dart';
import 'package:sticker_import/components/ui/body_padding.dart';
import 'package:sticker_import/components/ui/large_text.dart';
import 'package:sticker_import/components/ui/logo.dart';
import 'package:sticker_import/components/ui/round_button.dart';
import 'package:sticker_import/flows/export/progress.dart';
import 'package:sticker_import/flows/settings/about.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/account.dart';
import 'package:sticker_import/utils/check_updates.dart';

final _formKey = GlobalKey<FormState>();
bool isWithBorder = true;

void goOn(BuildContext context, TextEditingController urlController) {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  var v = urlController.value.text;
  v = v.trim();

  if (!v.startsWith('http://') && !v.startsWith('https://')) {
    v = 'https://' + v;
  }

  var u = Uri.parse(v);

  u = u.replace(host: 'vk.com', scheme: 'https');

  final account = Account.from('', 0);
  account.vk.onRequestStateChange = print;

  urlController.clear();

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (BuildContext context) {
        return ExportProgressFlow(
          account: account,
          uri: u,
          isWithBorder: isWithBorder,
        );
      },
    ),
  );
}

class StartRoute extends StatefulWidget {
  @override
  _StartRouteState createState() => _StartRouteState();
}

class _StartRouteState extends State<StartRoute> {
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    checkUpdates(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                LargeText(S.of(context).welcome),
                BodyPadding(
                  child: Text(
                    S.of(context).welcome_screen_description,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                BodyPadding(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Theme(
                          data:
                              (Theme.of(context).brightness == Brightness.light
                                  ? Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                      primary: Color(0xFFAC1B24),
                                    ))
                                  : Theme.of(context)),
                          child: TextFormField(
                            controller: urlController,
                            decoration: InputDecoration(
                              labelText: S.of(context).link,
                              border: OutlineInputBorder(),
                            ),
                            textInputAction: TextInputAction.go,
                            keyboardType: TextInputType.url,
                            autocorrect: false,
                            onEditingComplete: () {
                              goOn(context, urlController);
                            },
                            validator: (String? v) {
                              if (v == null) {
                                return S.of(context).link_incorrect;
                              }

                              v = v.trim();

                              if (!v.startsWith('http://') &&
                                  !v.startsWith('https://')) v = 'https://' + v;

                              var u = Uri.tryParse(v);
                              if (u == null) {
                                return S.of(context).link_incorrect;
                              }

                              if (u.host == 'm.vk.com') {
                                u = u.replace(host: 'vk.com', scheme: 'https');
                              }
                              if (u.host != 'vk.com' ||
                                  u.pathSegments.length != 2 ||
                                  u.pathSegments[0] != 'stickers') {
                                print(u.pathSegments);
                                return S.of(context).link_not_pack;
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                        SwitchListTile(
                          value: isWithBorder,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          title: Text(S.of(context).with_border),
                          onChanged: (n) {
                            setState(() {
                              isWithBorder = n;
                            });
                          },
                        ),
                        SizedBox(height: 30.0),
                        Column(
                          children: [
                            IconRoundButton(
                              icon: Icons.arrow_forward_rounded,
                              child: S.of(context).start,
                              onPressed: () {
                                goOn(context, urlController);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                BodyPadding(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Finish buttons
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return AboutRoute();
                              },
                            ),
                          );
                        },
                        child: Text(S.of(context).about_program),
                      ),
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
