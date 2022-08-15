import 'package:flutter/material.dart';
import 'package:sticker_import/services/connection/account.dart';

class VkStickerStoreRoute extends StatelessWidget {
  const VkStickerStoreRoute({required this.account, super.key});

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(account.name),
      ),
    );
  }
}
