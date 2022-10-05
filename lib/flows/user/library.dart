import 'package:flutter/material.dart';
import 'package:sticker_import/generated/l10n.dart';

class AddedStickerPacksLibraryRoute extends StatelessWidget {
  const AddedStickerPacksLibraryRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).my_stickers,
        ),
      ),
      body: Center(
        child: Text(
          S.of(context).my_stickers,
        ),
      ),
    );
  }
}
