import 'package:flutter/foundation.dart';
import 'package:sticker_import/services/connection/constants.dart';
import 'package:sticker_import/utils/debugging.dart';
import 'package:vkget/types.dart';
import 'package:vkget/vkget.dart';
import './connection.dart';
import './proxy.dart';

class Account {
  Account(this.vk, this.id, {this.name = '', this.uid = 0});

  factory Account.from(String token, int id,
      {String? language, String name = '', int uid = 0}) {
    final client = VKGet(
      AuthConstants.apiVersion,
      token,
      language: language,
      domain: VkConnection.apiDomain.toString(),
      oauthDomain: VkConnection.oauthDomain.toString(),
    );

    if (kDebugMode) {
      client.onRequestStateChange = (trace) {
        if (trace.type == VKGetTraceRequestType.fetch) return;
        iLog(trace.toStringRepresentation(censored: false));
      };
    } else {
      client.onRequestStateChange = (trace) {
        if (trace.type == VKGetTraceRequestType.fetch) return;
        iLog(trace.toString());
      };
    }

    return Account(client, id, name: name, uid: uid);
  }

  final VKGet vk;
  int id, uid;
  String name;

  @override
  bool operator ==(other) {
    return identical(this, other);
  }

  @override
  int get hashCode {
    return Object.hash(id, uid, name, vk.token);
  }

  DateTime? _fired;
  bool automaticProxy = false;

  DateTime? get fired => _fired;

  Future<void> fire({String? language, bool force = false}) async {
    if (language != null) vk.language = language;
    if (_fired != null && !force) return;

    if (await vk.initConnection()) {
      automaticProxy = true;
    } else {
      vk.resetProxy();
      automaticProxy = false;
    }

    _fired = DateTime.now();
  }

  Future<void> refresh() async {
    final Map<String, dynamic> data =
        (await vk.call('users.get', <String, String>{})).asJson()
            as Map<String, dynamic>;

    name =
        '${data['response'][0]['first_name'] as String} ${data['response'][0]['last_name'] as String}';
    uid = data['response'][0]['id'] as int;
  }

  Future<VKGetResponse> logout() {
    return vk.call(
      'auth.logout',
      <String, String>{
        'client_id': AuthConstants.clientId,
      },
    );
  }
}
