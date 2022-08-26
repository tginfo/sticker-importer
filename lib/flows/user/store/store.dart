import 'package:flutter/material.dart';
import 'package:sticker_import/components/types/account.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/services/connection/account.dart';

class VkStickerStoreRoute extends StatefulWidget {
  const VkStickerStoreRoute({super.key});

  @override
  State<VkStickerStoreRoute> createState() => _VkStickerStoreRouteState();
}

class _VkStickerStoreRouteState extends State<VkStickerStoreRoute> {
  late Account account;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    account = AccountData.of(context)!.account;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).sticker_store),
      ),
      body: Center(
        child: Text(account.name),
      ),
    );
  }
}
