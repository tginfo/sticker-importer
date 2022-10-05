import 'package:flutter/material.dart';
import 'package:sticker_import/services/connection/account.dart';
import 'package:sticker_import/services/connection/connection.dart';
import 'package:sticker_import/services/connection/constants.dart';
import 'package:sticker_import/services/connection/user_list.dart';
import '/generated/l10n.dart';

Future<Account?> createToken(
  BuildContext context,
  String username,
  String password,
) async {
  try {
    final locale = S.of(context).code;
    final authObj = Account.from('', 0, language: locale);
    UserList.connectToGui(authObj, context);
    await authObj.fire(language: locale);

    final token = await loginFlow(authObj, username, password);
    authObj.vk.token = token;
    await authObj.refresh();
    return authObj;
  } catch (e) {
    Navigator.of(context).pop();
    // ignore: unawaited_futures
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.of(context).error),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(S.of(context).ok),
              ),
            ],
          );
        });

    rethrow;
  }
}

Future<String> loginFlow(Account account, String username, String password,
    {String? code}) async {
  final requestBody = <String, String>{
    'grant_type': 'password',
    'username': username,
    'password': password,
    'client_id': AuthConstants.clientId,
    'client_secret': AuthConstants.clientSecret,
    '2fa_supported': '1',
    if (code != null) 'code': code
  };

  late String accessToken;

  try {
    final oauth = await account.vk.call(
      'token',
      requestBody,
      oauth: true,
    );

    final Map<String, dynamic> oauthRes =
        oauth.asJson() as Map<String, dynamic>;

    accessToken = oauthRes['access_token'] as String;
    if (oauthRes['access_token'] == null) throw TypeError();
  } catch (e) {
    if (e is Map<String, dynamic>) {
      throw VkException(e['error_description']);
    }

    rethrow;
  }

  return accessToken;
}
