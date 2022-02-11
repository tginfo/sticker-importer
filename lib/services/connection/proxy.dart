import 'package:vkget/vkget.dart';
import 'vkget_flutter.dart';

class NoInternetConnectionError extends Error {}

extension VkGetProxy on VKGet {
  Future<bool> initConnection() async {
    Duration? ping;

    try {
      print('Checking VK access');
      ping = await VKGetUtils.pingVK(client, timeout: Duration(seconds: 1));
      print('VK ping succeeded in $ping. No proxy needed');
      return false;
    } catch (e) {
      print('Getting VK proxies');
      final r = await VKGetUtilsFlutter.getProxyListAsAndroidDevice();

      print('Loaded proxy list from Firebase');
      VKGetUtils.trustify(r.certificates, client);
      proxies = r.proxy;
      Object? lastError;
      for (final proxy in r.proxy) {
        try {
          print('Trying proxy $proxy');
          ping = await VKGetUtils.pingVK(client,
              proxy: proxy, timeout: Duration(seconds: 1));
          break;
        } catch (e) {
          lastError = e;
        }
      }

      if (ping == null) {
        print("Couldn't find a working proxy");

        if (!await VKGetUtils.checkPureInternetConnection()) {
          print('No Internet detection');
          throw NoInternetConnectionError();
        }

        if (lastError != null) throw lastError;
        throw Exception('Unknown error');
      }

      print('Activated VK proxy');
      return true;
    }
  }

  void resetProxy() {
    VKGetUtils.trustify({}, client);
    proxies = {};
  }
}
