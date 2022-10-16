import 'package:flutter/material.dart';
import 'package:sticker_import/flows/user/actions.dart';
import 'package:sticker_import/services/connection/user_list.dart';

import 'store.dart';

Future<void> openStickerStore(BuildContext context) async {
  final navigator = Navigator.of(context);
  if (await getDoNotAskAboutStickerStoreLogin()) {
    launchStickerStoreInWeb(context);
    return;
  }

  final account = await getCurrentAccount(
    context,
    intent: VkAuthIntent.store,
  );

  if (account == null) return;

  return await navigator.push<void>(
    MaterialPageRoute(
      builder: (BuildContext context) {
        return AccountData(
          account: account,
          child: const VkStickerStoreRoute(),
        );
      },
    ),
  );
}
