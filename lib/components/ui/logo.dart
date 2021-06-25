import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoAsset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0),
      child: SvgPicture.asset(
        Theme.of(context).brightness == Brightness.dark
            ? 'assets/logo-dark.svg'
            : 'assets/logo.svg',
        semanticsLabel: 'tginfo mover',
      ),
    );
  }
}
