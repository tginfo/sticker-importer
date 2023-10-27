import 'package:flutter/material.dart';
import 'package:sticker_import/components/icons/custom_icons_icons.dart';
import 'package:sticker_import/components/ui/round_button.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/account.dart';
import 'package:sticker_import/utils/loading_popup.dart';
import 'package:url_launcher/url_launcher.dart';

import 'create_token.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute({super.key});

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  var isPasswordObscured = true;

  @override
  void dispose() {
    super.dispose();

    loginController.dispose();
    passwordController.dispose();
  }

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
        if (!context.mounted) return;

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

      if (!mounted) return;

      loginController.clear();
      passwordController.clear();

      Navigator.of(context).pop();
      Navigator.of(context).pop<Account>(authResult);
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: Theme.of(context).indicatorColor,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CustomIcons.vk,
                          size: 64, color: Color(0x7D929292)),
                      const SizedBox(height: 64.0),
                      TextFormField(
                        controller: loginController,
                        //autofocus: true,
                        autofillHints: const [AutofillHints.username],
                        decoration: InputDecoration(
                          labelText: S.of(context).login,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.person_rounded),
                        ),
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => node.nextFocus(),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: passwordController,
                        obscureText: isPasswordObscured,
                        autofillHints: const [AutofillHints.password],
                        decoration: InputDecoration(
                          labelText: S.of(context).password,
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock_rounded),
                          suffixIcon: IconButton(
                            icon: isPasswordObscured
                                ? const Icon(Icons.visibility_rounded)
                                : const Icon(Icons.visibility_off_rounded),
                            onPressed: () {
                              setState(() {
                                isPasswordObscured = !isPasswordObscured;
                              });
                            },
                          ),
                        ),
                        textInputAction: TextInputAction.go,
                        onEditingComplete: authFunc,
                      ),
                      const SizedBox(height: 30.0),
                      Column(
                        children: [
                          IconRoundButton(
                            icon: Icons.arrow_forward_rounded,
                            label: S.of(context).sign_in,
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
                              isThreeLine: true,
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
                                      foregroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                    onPressed: () {
                                      launchUrl(
                                        Uri.parse(
                                            S.of(context).vk_id_security_link),
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
          ],
        ),
      ),
    );
  }
}
