import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MethodChannelStore {
  static PackageInfo? packageInfo;
  static const MethodChannel intentChannel =
      MethodChannel('me.tginfo.stickerexport/DrKLOIntent');
}
