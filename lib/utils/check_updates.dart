import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:sticker_import/components/ui/large_text.dart';
import 'package:sticker_import/generated/l10n.dart';
import 'package:sticker_import/utils/debugging.dart';
import 'package:url_launcher/url_launcher.dart';

void checkUpdates(BuildContext context) async {
  final supportedAbis = (await DeviceInfoPlugin().androidInfo).supportedAbis;

  final res = await (await HttpClient().getUrl(
    Uri.parse('https://api.github.com/repositories/379931593/releases'),
  ))
      .close();

  final j = (await res
      .transform<String>(utf8.decoder)
      .transform<Object?>(json.decoder)
      .first) as List<dynamic>;

  Map<String, dynamic>? targetRelease;
  Map<String, dynamic>? targetFile;
  Map<String, dynamic>? fatTargetFile;
  final build = int.parse((await PackageInfo.fromPlatform()).buildNumber);
  iLog('My build is $build');

  for (final release in j) {
    if (release['prerelease'] == true) continue;
    final b = int.tryParse((release['tag_name'] as String).split('+').last);
    if (b == null || b <= build) {
      continue;
    }

    abiSearch:
    for (final abi in supportedAbis) {
      for (final Map<String, dynamic> asset in release['assets']) {
        final f = p.extension(asset['name'] as String, 1);
        if (f != '.apk') continue;

        final fs = p.extension(asset['name'] as String, 2);
        if (fatTargetFile == null && fs == '.fat.apk') {
          fatTargetFile = asset;
        }

        if (fs != '.$abi.apk') continue;

        targetFile = asset;
        iLog('Found matching package for ABI $abi');
        break abiSearch;
      }
    }

    if (targetFile == null && fatTargetFile != null) {
      targetFile = fatTargetFile;
      iLog('Using a fat APK');
    }

    if (targetFile != null) {
      targetRelease = release as Map<String, dynamic>;
      break;
    }
  }

  iLog(supportedAbis);

  if (targetRelease == null || targetFile == null) {
    iLog(
        'No updates found: ${targetRelease == null ? 'No new package' : 'Asset not found'}');
    return;
  }

  await showModalBottomSheet<dynamic>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: WidgetsBinding.instance.window.padding.top),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: LargeText(S.of(context).update),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(targetRelease!['body'] as String),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    launchUrl(
                        Uri.parse('https://apps.tginfo.me/sticker-import/'));
                  },
                  child: Text(S.of(context).open_in_browser),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    launchUrl(Uri.parse(
                        targetFile!['browser_download_url'] as String));
                  },
                  icon: Icon(Icons.download),
                  label: Text(S.of(context).download),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
