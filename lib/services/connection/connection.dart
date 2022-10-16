import 'account.dart';

class VkConnection {
  static Uri apiDomain =
      Uri(host: 'api.vk.com', scheme: 'https', pathSegments: ['method']);
  static Uri oauthDomain = Uri(host: 'oauth.vk.com', scheme: 'https');
  static Account? user;
}

class VkException extends Error {
  final dynamic message;

  VkException(this.message) : super();

  @override
  String toString() => message.toString();
}
