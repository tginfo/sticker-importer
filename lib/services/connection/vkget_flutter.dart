import 'package:device_info_plus/device_info_plus.dart';
import 'package:vkget/vkget.dart';

class VKGetUtilsFlutter extends VKGetUtils {
  static Future<VKProxyList> getProxyListAsAndroidDevice() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    final sdk = androidInfo.version.sdkInt;
    final version = androidInfo.version.release;
    final device = androidInfo.model;

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
