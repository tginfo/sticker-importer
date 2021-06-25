import 'package:flutter/material.dart';

class LargeText extends StatelessWidget {
  LargeText(this.data);
  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
      child: Text(
        data,
        style: TextStyle(
          fontFamily: 'Open Sans',
          fontSize: 36.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
