import 'package:sticker_import/utils/debugging.dart';
import 'package:vkget/vkget.dart';
import 'vkget_flutter.dart';

class NoInternetConnectionError extends Error {}

extension VkGetProxy on VKGet {
  Future<bool> initConnection() async {
    Duration? ping;

    try {
      iLog('Checking VK access');
      ping = await VKGetUtils.pingVK(client, timeout: Duration(seconds: 2));
      iLog('VK ping succeeded in $ping. No proxy needed');
      return false;
    } catch (e) {
      iLog('Getting VK proxies');
      final r = await VKGetUtilsFlutter.getProxyListAsAndroidDevice();

      iLog('Loaded proxy list from Firebase');
      VKGetUtils.trustify(r.certificates, client);
      proxies = r.proxy;
      Object? lastError;
      for (final proxy in r.proxy) {
        try {
          iLog('Trying proxy $proxy');
          ping = await VKGetUtils.pingVK(client,
              proxy: proxy, timeout: Duration(seconds: 1));
          break;
        } catch (e) {
          lastError = e;
        }
      }

      if (ping == null) {
        iLog("Couldn't find a working proxy");

        if (!await VKGetUtils.checkPureInternetConnection()) {
          iLog('No Internet detection');
          throw NoInternetConnectionError();
        }

        if (lastError != null) throw lastError;
        throw Exception('Unknown error');
      }

      iLog('Activated VK proxy');
      return true;
    }
  }

  void resetProxy() {
    VKGetUtils.trustify({}, client);
    proxies = {};
  }
}
