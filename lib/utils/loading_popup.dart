import 'package:flutter/material.dart';
import 'package:sticker_import/generated/l10n.dart';

Future<void> showLoadingPopup(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
          content: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 20.0),
          Text(S.of(context).loading),
        ],
      ));
    },
  );
}
