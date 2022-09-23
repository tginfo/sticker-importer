import 'package:flutter/material.dart';

ButtonStyle storeButtonStyle(BuildContext context) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
      Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onPrimary,
    ),
    foregroundColor: MaterialStateProperty.all<Color>(
      Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.onPrimary
          : Theme.of(context).colorScheme.primary,
    ),
    overlayColor: MaterialStateProperty.all<Color>(
        Theme.of(context).colorScheme.primary.withAlpha(50)),
  );
}
