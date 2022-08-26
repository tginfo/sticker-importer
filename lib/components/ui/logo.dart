import 'package:flutter/material.dart';

class LogoAsset extends StatelessWidget {
  const LogoAsset({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Image.asset(
        Theme.of(context).brightness == Brightness.dark
            ? 'assets/logo-dark.webp'
            : 'assets/logo.webp',
        width: 200.0,
      ),
    );
  }
}
