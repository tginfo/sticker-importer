import 'package:flutter/material.dart';
import 'package:sticker_import/flows/export/finish.dart';
import 'package:sticker_import/services/native/method_channels.dart';
import 'package:sticker_import/utils/debugging.dart';

void checkSupport(BuildContext context) async {
  try {
    final result = await MethodChannelStore.intentChannel.invokeMethod<String>(
      'checkForTelegramSupport',
      <String, dynamic>{
        'package': MethodChannelStore.packageInfo!.packageName,
      },
    );

    if (result == 'ok') return;

    iLog('NO TELEGRAM DETECTED: $result');

    // ignore: unawaited_futures, use_build_context_synchronously
    noTelegramAppAlert(context, result ?? 'idk');
  } catch (e) {
    iLog(e);
  }
}
