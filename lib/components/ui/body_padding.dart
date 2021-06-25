import 'package:flutter/material.dart';

class BodyPadding extends StatelessWidget {
  BodyPadding({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.0),
      child: child,
    );
  }
}
