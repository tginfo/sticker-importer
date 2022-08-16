import 'package:flutter/material.dart';
import 'package:sticker_import/components/icons/custom_icons_icons.dart';
import 'package:sticker_import/components/ui/round_button.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/account.dart';
import 'package:sticker_import/services/connection/user_list.dart';
import 'package:sticker_import/utils/loading_popup.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../start/nav.dart';
import 'create_token.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute({Key? key}) : super(key: key);

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    Future<void> authFunc() async {
      if (loginController.value.text.isEmpty ||
          passwordController.value.text.isEmpty) {
        // ignore: unawaited_futures
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S.of(context).error),
              content: Text(S.of(context).fill_all_fields),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    S.of(context).ok,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            );
          },
        );
        return;
      }

// ignore: unawaited_futures
      showLoadingPopup(context);

      final Account? authResult;

      if (!mounted) return;
      try {
        authResult = await createToken(
          context,
          loginController.text,
          passwordController.text,
        );
        if (authResult == null) return;
      } catch (e) {
        Navigator.of(context).pop();
        if (e is Map<String, dynamic>) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e['error_description'] as String),
          ));
          return;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
          ));
        }

        if (e == false) {
          return;
        }
        rethrow;
      }

      await UserList.update();
      for (final acc in UserList.data) {
        if (acc.uid == authResult.uid) {
          await UserList.dbRemove(acc.id);
        }
      }

      final curId = await UserList.dbRecord(authResult);
      await UserList.update();

      if (!mounted) return;
      UserList.setCurrent(
        UserList.data.firstWhere((element) => element.id == curId),
        context,
      );

      loginController.clear();
      passwordController.clear();

      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return const StartRoute(tab: StartRouteScreen.login);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            child: ListView(
              shrinkWrap: true,
              children: [
                const Icon(CustomIcons.vk, size: 64, color: Color(0x7D929292)),
                const SizedBox(height: 64.0),
                TextFormField(
                  controller: loginController,
                  autofocus: true,
                  autofillHints: const [AutofillHints.username],
                  decoration: InputDecoration(
                    labelText: S.of(context).login,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => node.nextFocus(),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  decoration: InputDecoration(
                    labelText: S.of(context).password,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  textInputAction: TextInputAction.go,
                  onEditingComplete: authFunc,
                ),
                const SizedBox(height: 30.0),
                Column(
                  children: [
                    IconRoundButton(
                      icon: Icons.arrow_forward_rounded,
                      child: S.of(context).sign_in,
                      onPressed: authFunc,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Card(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.onSecondary,
                          foregroundColor:
                              Theme.of(context).colorScheme.secondary,
                          child: const Icon(Icons.back_hand_rounded),
                        ),
                        title: Text(S.of(context).vk_id_setting_title),
                        subtitle: Text(S.of(context).vk_id_setting_info),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5.0,
                          right: 15.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary:
                                    Theme.of(context).colorScheme.onPrimary,
                                onPrimary:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                launchUrl(
                                  Uri.parse(S.of(context).vk_id_security_link),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              child: Text(S.of(context).go_to_vk_id),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
