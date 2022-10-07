import 'package:flutter/material.dart';
import 'package:sticker_import/services/connection/account.dart';

void vmojiWizard({
  required BuildContext context,
  required Account account,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('VK Vmoji Import is under development'),
    ),
  );
}
