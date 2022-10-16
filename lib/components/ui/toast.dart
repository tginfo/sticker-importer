import 'package:flutter/material.dart';

enum StatusToastType { normal, success, error }

Widget statusToast({
  StatusToastType type = StatusToastType.normal,
  required Widget child,
  Widget? leading,
  required BuildContext context,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: (type == StatusToastType.success
          ? Colors.greenAccent
          : (type == StatusToastType.error &&
                  Theme.of(context).brightness != Brightness.dark
              ? Colors.redAccent
              : Colors.black.withAlpha(200))),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) leading,
        if (leading != null)
          const SizedBox(
            width: 12.0,
          ),
        DefaultTextStyle(
            style: TextStyle(color: Colors.black.withAlpha(200)), child: child),
      ],
    ),
  );
}
