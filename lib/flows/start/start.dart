import 'package:flutter/material.dart';
import 'package:sticker_import/components/ui/body_padding.dart';
import 'package:sticker_import/components/ui/large_text.dart';
import 'package:sticker_import/components/ui/logo.dart';
import 'package:sticker_import/components/ui/round_button.dart';
import 'package:sticker_import/export/controllers/vk.dart';
import 'package:sticker_import/flows/export/progress.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/account.dart';
import 'package:sticker_import/utils/debugging.dart';
import 'package:url_launcher/url_launcher.dart';

class ImportByLinkRoute extends StatefulWidget {
  const ImportByLinkRoute({Key? key}) : super(key: key);

  @override
  ImportByLinkRouteState createState() => ImportByLinkRouteState();
}

class ImportByLinkRouteState extends State<ImportByLinkRoute> {
  final urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isWithBorder = true;

  void goOn(BuildContext context, TextEditingController urlController) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    var v = urlController.value.text;
    v = v.trim();

    if (!v.startsWith('http://') && !v.startsWith('https://')) {
      v = 'https://$v';
    }

    var u = Uri.parse(v);

    u = u.replace(host: 'vk.com', scheme: 'https');

    final account = Account.from('', 0, language: S.of(context).code);
    account.vk.onRequestStateChange = iLog;

    urlController.clear();

    Navigator.of(context).push<dynamic>(
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) {
          return ExportProgressFlow(
            controller: VkExportController(
              account: account,
              uri: u,
              isWithBorder: isWithBorder,
              context: context,
              onStyleChooser: (styles) => chooseYourFighter(context, styles),
              onShouldUseAnimated: () => shouldUseAnimated(context),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        TextFormField(
                          controller: urlController,
                          decoration: InputDecoration(
                            labelText: S.of(context).link,
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.link),
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

                            iLog('Input url: $v');

                            v = v.trim();

                            if (!v.startsWith('http://') &&
                                !v.startsWith('https://')) v = 'https://$v';

                            var u = Uri.tryParse(v);
                            if (u == null) {
                              return S.of(context).link_incorrect;
                            }

                            if (u.host == 'm.vk.com') {
                              u = u.replace(host: 'vk.com', scheme: 'https');
                            }

                            if (u.host != 'vk.com' &&
                                u.host != 'store.line.me') {
                              return S.of(context).link_incorrect;
                            }

                            if (u.host == 'vk.com') {
                              if (!(u.pathSegments.length == 2 &&
                                      u.pathSegments[0] == 'stickers') &&
                                  !(u.pathSegments[0] == 'stickers' &&
                                      u.queryParameters
                                          .containsKey('stickers_id'))) {
                                return S.of(context).link_not_pack_vk;
                              }
                            }

                            if (u.host == 'store.line.me') {
                              if (u.pathSegments.length < 3 ||
                                  !(u.pathSegments[0] == 'stickershop' ||
                                      u.pathSegments[1] == 'product' ||
                                      int.tryParse(u.pathSegments[2]) !=
                                          null)) {
                                return S.of(context).link_not_pack_line;
                              }
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 10.0),
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
                        const SizedBox(height: 30.0),
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
                          launchUrl(
                            Uri.parse(
                              S.of(context).vk_sticker_store_url,
                            ),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: Text(S.of(context).vk_sticker_store),
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
