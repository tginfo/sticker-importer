import 'package:flutter/material.dart';
import 'package:sticker_import/components/icons/custom_icons_icons.dart';
import 'package:sticker_import/components/ui/round_button.dart';
import 'package:sticker_import/flows/user/library.dart';
import 'package:sticker_import/flows/user/login/login.dart';
import 'package:sticker_import/flows/user/store/store.dart';
import 'package:sticker_import/flows/user/vmoji.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/account.dart';
import 'package:sticker_import/services/connection/user_list.dart';
import 'package:sticker_import/services/settings/settings.dart';
import 'package:url_launcher/url_launcher.dart';

class VkUserMenuRoute extends StatelessWidget {
  const VkUserMenuRoute({super.key, required this.intent});

  final VkAuthIntent? intent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: intent != null
            ? AppBar(
                title: Text(
                  S.of(context).vk_account,
                ),
              )
            : null,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: ListTileTheme.merge(
                  minLeadingWidth: 40,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  iconColor: Theme.of(context).indicatorColor,
                  child: AccountData.of(context).account == null
                      ? VkPageSignedOut(
                          intent: intent,
                        )
                      : const VkPageSignedInMenu(),
                ),
              ),
            ),
          ),
        ));
  }
}

class VkPageSignedInMenu extends StatefulWidget {
  const VkPageSignedInMenu({super.key});

  @override
  State<VkPageSignedInMenu> createState() => _VkPageSignedInMenuState();
}

class _VkPageSignedInMenuState extends State<VkPageSignedInMenu> {
  void accountChooser(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(8),
        title: Text(S.of(context).choose_account),
        content: const AccountListChooser(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => accountChooser(context),
            child: FocusableActionDetector(
              actions: {
                ButtonActivateIntent: CallbackAction(
                  onInvoke: (action) async {
                    accountChooser(context);
                    return null;
                  },
                ),
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      CustomIcons.vk,
                      size: 48,
                      color: Theme.of(context).indicatorColor,
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AccountData.of(context).account!.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            S.of(context).tap_to_change_account,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(
            Icons.library_add_rounded,
          ),
          title: Text(S.of(context).my_stickers),
          onTap: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return AccountData(
                    account: AccountData.of(context).account,
                    child: const AddedStickerPacksRoute(),
                  );
                },
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.storefront_rounded,
          ),
          title: Text(S.of(context).sticker_store),
          onTap: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return AccountData(
                    account: AccountData.of(context).account,
                    child: const VkStickerStoreRoute(),
                  );
                },
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.search_rounded,
          ),
          title: Text(S.of(context).sticker_search),
          onTap: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return AccountData(
                    account: AccountData.of(context).account,
                    child: const VkStickerStoreRoute(showSearch: true),
                  );
                },
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.face_rounded,
          ),
          title: Text(S.of(context).vmoji),
          onTap: () {
            vmojiWizard(
              context: context,
              account: AccountData.of(context).account!,
            );
          },
        ),
      ],
    );
  }
}

class AccountListChooser extends StatefulWidget {
  const AccountListChooser({
    super.key,
  });

  @override
  State<AccountListChooser> createState() => _AccountListChooserState();
}

class _AccountListChooserState extends State<AccountListChooser> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...UserList.data.map(
            (e) => ListTile(
              title: Text(e.name.isEmpty ? 'User' : e.name),
              subtitle: e.uid == AccountData.of(context).account?.uid
                  ? Text(S.of(context).logged_in)
                  : null,
              leading: Icon(
                Icons.account_circle_rounded,
                size: 42.0,
                color: Theme.of(context).indicatorColor,
              ),
              onTap: () async {
                // ignore: unawaited_futures
                UserList.saveCurrent(e);

                if (!mounted) return;
                AccountChangeNotification(
                  e,
                ).dispatch(context);
                Navigator.of(context).pop();
              },
              trailing: IconButton(
                icon: const Icon(Icons.close_rounded),
                color: Theme.of(context).indicatorColor,
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(S.of(context).confirmation),
                        content: Text(S.of(context).delete_account_confirm),
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

                  // ignore: unawaited_futures
                  e.logout();
                  await UserList.dbRemove(e.id);
                  await UserList.update(language: locale);

                  final cur = UserList.current ??
                      (UserList.data.isNotEmpty ? UserList.data.first : null);
                  // ignore: unawaited_futures
                  UserList.saveCurrent(cur);

                  if (!mounted) return;
                  AccountChangeNotification(
                    cur,
                  ).dispatch(context);

                  if (UserList.data.isEmpty) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ),
          ListTile(
            leading: const CircleAvatar(
              child: Icon(
                Icons.add_rounded,
              ),
            ),
            onTap: () async {
              final navigator = Navigator.of(context);

              final account = await navigator.push<Account?>(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const LoginRoute();
                  },
                ),
              );

              if (account == null || !mounted) return;

              await recordAccount(account);
              await UserList.saveCurrent(account);
              if (!mounted) return;
              AccountChangeNotification(account).dispatch(context);
            },
            title: Text(S.of(context).add_account),
          ),
        ],
      ),
    );
  }
}

class VkPageSignedOut extends StatefulWidget {
  const VkPageSignedOut({super.key, required this.intent});

  final VkAuthIntent? intent;

  @override
  State<VkPageSignedOut> createState() => _VkPageSignedOutState();
}

class _VkPageSignedOutState extends State<VkPageSignedOut> {
  bool stickerStoreDoNotAsk = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CustomIcons.vk,
                size: 48,
                color: Theme.of(context).indicatorColor,
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  S.of(context).login_with_vk_to,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (widget.intent != null) _vkAuthIntentWidgets[widget.intent]!,
        if (widget.intent != null)
          Row(
            children: [
              const Expanded(
                child: Divider(
                  thickness: 1,
                ),
              ),
              const SizedBox(width: 16),
              Opacity(
                opacity: 0.5,
                child: Text(
                  S.of(context).and_also,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Divider(
                  thickness: 1,
                ),
              ),
            ],
          ),
        if (widget.intent != null) const SizedBox(height: 16),
        if (widget.intent != VkAuthIntent.library)
          const _VkAuthFeatureLibrary(),
        if (widget.intent != VkAuthIntent.store) const _VkAuthFeatureStore(),
        if (widget.intent != VkAuthIntent.search) const _VkAuthFeatureSearch(),
        if (widget.intent != VkAuthIntent.vmoji) const _VkAuthFeatureVmoji(),
        if (widget.intent != VkAuthIntent.suggestions)
          const _VkAuthFeatureSuggestions(),
        const SizedBox(height: 32),
        Align(
          alignment: AlignmentDirectional.center,
          child: SignInButton(
            intent: widget.intent,
          ),
        ),
        if (widget.intent != null) const SizedBox(height: 16),
        if (widget.intent != null) const Divider(),
        if (widget.intent == VkAuthIntent.store)
          OutlinedButton.icon(
            onPressed: () {
              launchStickerStoreInWeb(context);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.language_rounded),
            label: Center(child: Text(S.of(context).vk_sticker_store_web)),
          ),
        if (widget.intent == VkAuthIntent.store)
          CheckboxListTile(
            value: stickerStoreDoNotAsk,
            onChanged: (value) {
              setState(() {
                stickerStoreDoNotAsk = value!;
              });

              setDoNotAskAboutStickerStoreLogin(stickerStoreDoNotAsk);
            },
            title: Text(S.of(context).do_not_ask_again),
          ),
        if (widget.intent != null && widget.intent != VkAuthIntent.store)
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close_rounded),
            label: Center(child: Text(S.of(context).i_changed_my_mind)),
          ),
      ],
    );
  }
}

class SignInButton extends StatefulWidget {
  const SignInButton({
    this.intent,
    super.key,
  });

  final VkAuthIntent? intent;

  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  @override
  Widget build(BuildContext context) {
    return IconRoundButton(
      icon: Icons.arrow_forward_rounded,
      label: S.of(context).sign_in,
      onPressed: () async {
        final navigator = Navigator.of(context);

        final account = await navigator.push<Account?>(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const LoginRoute();
            },
          ),
        );

        if (account == null || !mounted) return;

        // ignore: unawaited_futures
        recordAccount(account).then(
          (value) {
            UserList.update(language: account.vk.language);
          },
        );
        await UserList.saveCurrent(account);

        if (!mounted) return;
        AccountChangeNotification(account).dispatch(context);

        if (widget.intent != null) navigator.pop(account);
      },
    );
  }
}

Future<void> recordAccount(Account account) async {
  for (final acc in UserList.data) {
    if (acc.uid == account.uid) {
      await UserList.dbRemove(acc.id);
    }
  }

  await UserList.dbRecord(account);
}

enum VkAuthIntent {
  library,
  store,
  search,
  vmoji,
  suggestions,
}

const _vkAuthIntentWidgets = <VkAuthIntent, Widget>{
  VkAuthIntent.library: _VkAuthFeatureLibrary(),
  VkAuthIntent.store: _VkAuthFeatureStore(),
  VkAuthIntent.search: _VkAuthFeatureSearch(),
  VkAuthIntent.vmoji: _VkAuthFeatureVmoji(),
  VkAuthIntent.suggestions: _VkAuthFeatureSuggestions(),
};

class _VkAuthFeatureLibrary extends StatelessWidget {
  const _VkAuthFeatureLibrary();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.library_add_rounded,
      ),
      title: Text(S.of(context).login_with_vk_to_library),
    );
  }
}

class _VkAuthFeatureStore extends StatelessWidget {
  const _VkAuthFeatureStore();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.storefront_rounded,
      ),
      title: Text(S.of(context).login_with_vk_to_store),
    );
  }
}

class _VkAuthFeatureSearch extends StatelessWidget {
  const _VkAuthFeatureSearch();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.search_rounded,
      ),
      title: Text(S.of(context).login_with_vk_to_search),
    );
  }
}

class _VkAuthFeatureVmoji extends StatelessWidget {
  const _VkAuthFeatureVmoji();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.face_rounded,
      ),
      title: Text(S.of(context).login_with_vk_to_vmoji),
    );
  }
}

class _VkAuthFeatureSuggestions extends StatelessWidget {
  const _VkAuthFeatureSuggestions();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.auto_fix_high_rounded,
      ),
      title: Text(S.of(context).login_with_vk_to_suggestions),
    );
  }
}

Future<Account?> getCurrentAccount(
  BuildContext context, {
  VkAuthIntent? intent,
}) async {
  final account = AccountData.of(context).account;
  if (account != null) return account;

  final authDone = Navigator.of(context).push<Account?>(
    MaterialPageRoute(
      builder: (BuildContext context) {
        return VkUserMenuRoute(
          intent: intent,
        );
      },
    ),
  );

  return authDone;
}

Future<bool> getDoNotAskAboutStickerStoreLogin() async {
  return await SettingsStorage.of('main')
          .get<bool?>('store_login_prompt_seen') ??
      false;
}

Future<void> setDoNotAskAboutStickerStoreLogin(bool value) async {
  return await SettingsStorage.of('main')
      .set<bool>('store_login_prompt_seen', value);
}

void launchStickerStoreInWeb(BuildContext context) {
  launchUrl(
    Uri.parse(
      S.of(context).vk_sticker_store_url,
    ),
    mode: LaunchMode.externalApplication,
  );
}
