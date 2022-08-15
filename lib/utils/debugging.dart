import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';

final Directory _generalDownloadDir = Directory('/storage/emulated/0/Download');

StringBuffer _logs = StringBuffer();
bool iLogDoDetailedLogging = kDebugMode;

void iLog(Object? message, {bool large = true}) {
  if (large && !iLogDoDetailedLogging) return;

  if (message is String) {
    log(message);
  } else {
    // ignore: avoid_print
    print(message.toString());
  }
  if (iLogDoDetailedLogging) _logs.writeln(message);
}

Future<File> _logFileName() async {
  int logCounter = 0;
  File? result;

  do {
    final variant = File(
      '${_generalDownloadDir.path}/'
      'tginfo_log${logCounter > 0 ? '_$logCounter' : ''}.txt',
    );
    if (await variant.exists()) {
      logCounter++;
    } else {
      result = variant;
    }
  } while (result == null);

  return result;
}

String _getLogs() {
  return _logs.toString();
}

Future<File> saveLogs() async {
  final File logFile = await _logFileName();
  await logFile.writeAsString(_getLogs(), flush: true);
  return logFile;
}
