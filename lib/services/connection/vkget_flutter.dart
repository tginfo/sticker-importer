import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:vkget/vkget.dart';

class VKGetUtilsFlutter extends VKGetUtils {
  static Future<VKProxyList> getProxyListAsAndroidDevice() async {
    int? sdk;
    String? version;
    String? device;

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      sdk = androidInfo.version.sdkInt;
      version = androidInfo.version.release;
      device = androidInfo.model;
    }

    try {
      return await VKGetUtils.getProxyList(
        sdk: sdk,
        version: version,
        device: device,
      );
    } catch (e) {
      return VKProxyList({}, {});
    }
  }
}
