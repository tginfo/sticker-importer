import 'package:flutter/material.dart';
import 'package:sticker_import/components/ui/store_button_style.dart';
import 'package:sticker_import/flows/user/store/pack.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/account.dart';
import 'package:sticker_import/services/connection/store.dart';
import 'package:sticker_import/utils/debugging.dart';
import 'package:sticker_import/utils/loading_popup.dart';

void vmojiWizard({
  required BuildContext context,
  required Account account,
}) async {
  final url = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    builder: (context) => VkVmojiImportSettingsBottomSheet(
      account: account,
    ),
  );

  if (url == null) {
    return;
  }

  iLog('VMOJI: $url');

  // ignore: unawaited_futures, use_build_context_synchronously
  showLoadingPopup(context);

  try {
    // ignore: use_build_context_synchronously
    await account.fire(language: S.of(context).code);
    final userResolve =
        (await account.vk.call('utils.resolveScreenName', <String, String>{
      'screen_name': Uri.parse(url).pathSegments[0],
    }))
            .asJson() as Map<String, dynamic>;

    final dynamic response = userResolve['response'];

    if (response is! Map<String, dynamic> || response['type'] != 'user') {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // ignore: use_build_context_synchronously
          content: Text(S.of(context).link_incorrect),
        ),
      );
      return;
    }

    final userId = response['object_id'] as int;
    iLog('VMOJI User ID: $userId');

    // ignore: use_build_context_synchronously
    final pack = await getVmojiPack(userId, account, context);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();

    if (pack == null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // ignore: use_build_context_synchronously
          content: Text(S.of(context).vmoji_user_does_not_use_vmoji),
        ),
      );
      return;
    }

    if (!context.mounted) return;
    vkStoreStickerPackPopup(pack: pack, account: account, context: context);
  } catch (e) {
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // ignore: use_build_context_synchronously
        content: Text(e.toString()),
      ),
    );
    rethrow;
  }
}

Future<VkStickerStorePack?> getVmojiPack(
    int userId, Account account, BuildContext context) async {
  final ref = ((await account.vk
          .call('vmoji.getStickerPacksRecommendationBlocks', <String, String>{
    'ref_user_id': userId.toString(),
  }))
      .asJson() as Map<String, dynamic>)['response'] as Map<String, dynamic>;

  final searchPattern =
      RegExp('^https://vk.com/sticker/packs/1554_.{6}(.+)/.+');

  final packs = ref['packs'] as List<dynamic>;

  if (packs.isEmpty) {
    return null;
  }

  final baseUrl = (((packs[0] as Map<String, dynamic>?)?['icon']
      as Map<String, dynamic>?)?['base_url'] as String?);

  if (baseUrl == null) {
    return null;
  }

  final characterId = searchPattern.firstMatch(baseUrl)!.group(1)!;

  final pack = VkStickerStorePack.fromJson(
    ((await account.vk.call('store.getStockItemByProductId', <String, String>{
      'type': 'stickers',
      'product_id': '1554',
      'vmoji_character_id': characterId,
    }))
        .asJson() as Map<String, dynamic>)['response'] as Map<String, dynamic>,
    await account.getStickersImageConfig(),
  );

  return pack;
}

class VkVmojiImportSettingsBottomSheet extends StatelessWidget {
  const VkVmojiImportSettingsBottomSheet({
    super.key,
    required this.account,
  });

  final Account account;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    S.of(context).vmoji_import,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(S.of(context).vmoji_own_or_user),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        // show alert
                        final String? url = await showDialog<String>(
                          context: context,
                          builder: (context) => const VkVmojiUrlInputAlert(),
                        );

                        if (url == null) return;

                        navigator.pop(url);
                      },
                      child: Text(S.of(context).vmoji_user),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      style: storeButtonStyle(context),
                      onPressed: () {
                        Navigator.of(context).pop(
                          'https://vk.com/id${account.uid}',
                        );
                      },
                      child: Text(S.of(context).vmoji_own),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class VkVmojiUrlInputAlert extends StatefulWidget {
  const VkVmojiUrlInputAlert({
    super.key,
  });

  @override
  State<VkVmojiUrlInputAlert> createState() => _VkVmojiUrlInputAlertState();
}

class _VkVmojiUrlInputAlertState extends State<VkVmojiUrlInputAlert> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void goOn(BuildContext context) {
    final res = _formKey.currentState!.validate();
    if (!res) return;

    String text = _controller.text;

    if (!text.startsWith('http')) {
      text = 'https://$text';
    }

    final uri = Uri.parse(text);

    Navigator.of(context).pop(
      Uri(
        scheme: 'https',
        host: 'vk.com',
        pathSegments: [uri.pathSegments[0]],
      ).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: Text(S.of(context).vmoji_import),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.of(context).vmoji_user_url_desc),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: true,
              keyboardType: TextInputType.url,
              autofillHints: const [AutofillHints.url],
              autocorrect: false,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: S.of(context).vmoji_user_url,
                hintText: 'https://vk.com/durov',
              ),
              onEditingComplete: () => goOn(context),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).field_required;
                }

                String text = value;

                if (!text.startsWith('http')) {
                  text = 'https://$text';
                }

                Uri uri;

                try {
                  uri = Uri.parse(text);
                } catch (e) {
                  return S.of(context).link_incorrect;
                }

                if (uri.scheme == 'http') {
                  uri.replace(scheme: 'https');
                }

                if (uri.host == 'm.vk.com') {
                  uri = uri.replace(host: 'vk.com');
                }

                if (uri.scheme != 'https' ||
                    uri.host != 'vk.com' ||
                    uri.pathSegments.length != 1) {
                  return S.of(context).link_incorrect;
                }

                return null;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              goOn(context);
            },
            child: Text(S.of(context).ok),
          ),
        ],
      ),
    );
  }
}
