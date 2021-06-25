import 'package:flutter/material.dart';
import 'package:sticker_import/generated/l10n.dart';

const thresh = 1024;

String bytesToSize(int bytes, {required BuildContext context}) {
  final units = [
    S.of(context).unit_kb,
    S.of(context).unit_mb,
    S.of(context).unit_gb,
  ];

  if (bytes.abs() < thresh) return '$bytes ${S.of(context).unit_b}';

  var u = -1;
  var b = bytes.toDouble();
  do {
    b /= thresh;
    u++;
  } while (b.abs() >= thresh && u < units.length - 1);

  return '${b.toInt() == b ? b.toInt().toString() : b.toStringAsFixed(1)} ${units[u]}';
}
