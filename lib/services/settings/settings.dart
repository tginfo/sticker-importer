import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';

class SettingsStorage {
  static PackageInfo? packageInfo;
  static const MethodChannel intentChannel =
      MethodChannel('me.tginfo.stickerexport/DrKLOIntent');
}
