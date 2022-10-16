import 'package:flutter/material.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:url_launcher/url_launcher_string.dart';

void launchFeedback(BuildContext context) {
  launchTelegram('infowritebot', start: 'stickerimporter');
}

void launchTelegram(String domain, {String? start}) async {
  final deepLink =
      'tg://resolve?domain=${Uri.encodeComponent(domain)}${start != null ? '&start=${Uri.encodeComponent(start)}' : ''}';

  if (await canLaunchUrlString(deepLink)) {
    await launchUrlString(deepLink);
  } else {
    await launchUrlString(
        'https://t.me/${Uri.encodeComponent(domain)}${start != null ? '?start=${Uri.encodeComponent(start)}' : ''}');
  }
}

void launchDonate() {
  launchUrlString(
    'https://donate.tginfo.me',
    mode: LaunchMode.externalApplication,
  );
}

void launchChannel(BuildContext context) {
  launchTelegram(S.of(context).tginfo_tag);
}

void launchGitHub() {
  launchUrlString(
    'https://github.com/tginfo/sticker-importer',
    mode: LaunchMode.externalApplication,
  );
}
