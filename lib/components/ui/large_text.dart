import 'package:flutter/material.dart';

class LargeText extends StatelessWidget {
  const LargeText(this.data, {super.key});
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
      child: Text(
        data,
        style: const TextStyle(
          fontFamily: 'Open Sans',
          fontSize: 36.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
