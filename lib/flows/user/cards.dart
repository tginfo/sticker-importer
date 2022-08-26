import 'package:flutter/material.dart';
import 'package:sticker_import/components/types/account.dart';
import 'package:sticker_import/components/ui/body_padding.dart';
import 'package:sticker_import/components/ui/large_text.dart';
import 'package:sticker_import/components/ui/logo.dart';
import 'package:sticker_import/flows/start/nav.dart';
import 'package:sticker_import/flows/user/store/store.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/user_list.dart';
import 'package:sticker_import/utils/loading_popup.dart';

import 'login/login.dart';

class CardListRoute extends StatefulWidget {
  const CardListRoute({Key? key}) : super(key: key);

  @override
  State<CardListRoute> createState() => _CardListRouteState();
}

class _CardListRouteState extends State<CardListRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: const [
                  LogoAsset(),
                ],
              ),
              LargeText(S.of(context).vk_login),
              BodyPadding(
                child: Text(
                  S.of(context).vk_login_access,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              BodyPadding(
                child: Card(
                  elevation: 4,
                  clipBehavior: Clip.antiAlias,
                  shadowColor: Colors.black.withAlpha(100),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ...UserList.data.map(
                        (e) => ListTile(
                          onTap: () async {
                            UserList.setCurrent(e, context);

                            if (e.fired == null) {
                              // ignore: unawaited_futures
                              showLoadingPopup(context);

                              await e.fire(language: S.of(context).code);
                              if (!mounted) return;
                              Navigator.of(context).pop();
                            }

                            if (!mounted) return;
                            await Navigator.of(context).push<void>(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return AccountData(
                                    account: e,
                                    child: const VkStickerStoreRoute(),
                                  );
                                },
                              ),
                            );
                          },
                          leading: Icon(
                            Icons.account_circle_rounded,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).primaryColor),
                            size: 42.0,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () async {
                              final result = await showDialog<bool>(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(S.of(context).confirmation),
                                    content: Text(
                                        S.of(context).delete_account_confirm),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text(
                                          S.of(context).cancel,
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
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
                              if (result != true) return;

                              if (!mounted) return;
                              final locale = S.of(context).code;

                              await UserList.dbRemove(e.id);
                              await UserList.update(language: locale);

                              if (!mounted) return;
                              Navigator.of(context).pop();
                              await Navigator.of(context).push<void>(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return const StartRoute(
                                      tab: StartRouteScreen.login,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          title: Text(e.name.isEmpty ? 'User' : e.name),
                          subtitle: Text(S.of(context).logged_in),
                        ),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: (Theme.of(context).brightness ==
                                  Brightness.dark
                              ? Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withAlpha(50)
                              : Theme.of(context).primaryColor.withAlpha(50)),
                          foregroundColor:
                              (Theme.of(context).brightness == Brightness.dark
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).primaryColor),
                          child: const Icon(
                            Icons.add_rounded,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push<void>(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const LoginRoute();
                              },
                            ),
                          );
                        },
                        title: Text(S.of(context).add_account),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
