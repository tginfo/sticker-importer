import 'account.dart';

class VkConnection {
  static Uri apiDomain = Uri(host: 'api.vk.com', scheme: 'https');
  static Uri oauthDomain = Uri(host: 'oauth.vk.com', scheme: 'https');
  static Account? user;
}
