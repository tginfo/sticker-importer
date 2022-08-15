import 'package:flutter/material.dart';

class BodyPadding extends StatelessWidget {
  const BodyPadding({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: child,
    );
  }
}
