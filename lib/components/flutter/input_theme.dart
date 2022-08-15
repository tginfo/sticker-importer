import 'package:flutter/material.dart';
import 'package:sticker_import/components/flutter/theme_color.dart';

class InputTheme extends StatelessWidget {
  final Widget child;

  const InputTheme({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
        primarySwatch: ThemeColor.swatch,
      )),
      child: child,
    );
  }
}
