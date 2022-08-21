import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:idb_sqflite/idb_sqflite.dart';
import 'package:sticker_import/components/ui/toast.dart';
import 'package:sticker_import/utils/debugging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vkget/types.dart';
import 'package:vkget/vkget.dart';
import '/generated/l10n.dart';
import 'account.dart';
import '../db/db_keeper.dart';

class UserList {
  static final DbKeeper _database = DbKeeper('users.db', {
    1: DbKeeperStoreChanges(
      [
        (db, version, event) async {
          db.createObjectStore('main', autoIncrement: true);
        }
      ],
    ),
  });

  static Future<Database> Function() get init => _database.init;

  static Future<int> dbRecord(Account account) async {
    final r = await (await _database.writeTransaction('main')).put(
      <String, dynamic>{
        'token': account.vk.token.isEmpty ? null : account.vk.token,
        'date': DateTime.now().millisecondsSinceEpoch,
        'uid': account.uid,
        'name': account.name.isEmpty ? null : account.name,
      },
      account.id == 0 ? null : account.id,
    );
    account.id = r as int;
    await dbRemoveByUid(account.uid, except: r);
    await update();
    return account.id;
  }

  static Future<void> dbRemove(int id) async {
    await (await _database.writeTransaction('main')).delete(id);
  }

  static Future<void> dbRemoveByUid(int id, {int? except}) async {
    await for (final account
        in (await _database.writeTransaction('main')).openCursor()) {
      if ((account.value as Map<String, dynamic>)['uid'] == id &&
          account.key != except) {
        await account.delete();
      }
      account.next();
    }
  }

  static List<Account> data = [];

  static Future<void> update({String? language}) async {
    data.clear();

    await for (final account
        in (await _database.writeTransaction('main')).openCursor()) {
      final userData = account.value as Map<String, dynamic>;

      final user = Account.from(
        userData['token'] as String,
        account.key as int,
        language: language,
        name: userData['name'] as String,
        uid: userData['uid'] as int,
      );

      data.add(user);
      account.next();
    }
  }

  static Account? _current;

  static Account? get current => _current;

  static void setCurrent(Account account, BuildContext context) {
    /* account.vk.onConnectionProblems = () async {
      return (await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(S.of(context).internet_error_title),
                  content: Text(S.of(context).internet_error_info),
                  actions: [
                    TextButton(
                      child: Text(S.of(context).t_continue),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: Text(S.of(context).t_continue),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              })) ??
          false;
    }; */

    account.vk.onCaptcha = (r) async {
      final lang = S.of(context);
      final String imgUrl = r.asJson!['captcha_img'] as String;

      final response = await showDialog<String?>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          final captchaController = TextEditingController();

          void goOn() {
            Navigator.of(context).pop<String>(captchaController.text);
          }

          return Form(
            child: AlertDialog(
              title: Text(S.of(context).confirmation),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(S.of(context).enter_code_from_img),
                  FutureBuilder<List<int>>(
                    future: () async {
                      final req = await account.vk.fetch(Uri.parse(imgUrl));

                      final responseData = <int>[];
                      await for (final i in req) {
                        responseData.addAll(i);
                      }
                      return responseData;
                    }(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        iLog(snapshot.error);
                        return Text(S.of(context).error);
                      }

                      return Image.memory(Uint8List.fromList(snapshot.data!));
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    autofocus: true,
                    controller: captchaController,
                    decoration: InputDecoration(
                      labelText: S.of(context).captcha,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.security_rounded),
                    ),
                    textInputAction:
                        (Theme.of(context).platform == TargetPlatform.iOS
                            ? TextInputAction.continueAction
                            : TextInputAction.go),
                    onEditingComplete: goOn,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(S.of(context).cancel),
                ),
                TextButton(
                  onPressed: goOn,
                  child: Text(
                    S.of(context).ok,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          );
        },
      );

      if (response == null) throw lang.captcha_fail;

      return response;
    };

    account.vk.onNeedValidation = (r) async {
      final lang = S.of(context);
      final e = r.asJson as Map<String, dynamic>;

      var twofaValidation = false;
      var smsValidation = false;

      if (e['validation_type'] == '2fa_sms' ||
          e['validation_type'] == '2fa_app') {
        twofaValidation = true;
        if (e['validation_type'] == '2fa_sms') smsValidation = true;
      }

      if (!twofaValidation) {
        await launchUrl(Uri.parse(e['redirect_uri'] as String));
        throw lang.try_sending_request_again;
      }

      final result = await showDialog<String?>(
        context: context,
        builder: (BuildContext context) {
          final twofaController = TextEditingController();

          void goOn() {
            Navigator.of(context).pop(twofaController.text);
          }

          return AlertDialog(
            content: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    smsValidation
                        ? S.of(context).enter_code_from_sms
                        : S.of(context).enter_code_from_app,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    autofocus: true,
                    controller: twofaController,
                    keyboardType: TextInputType.number,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    decoration: InputDecoration(
                      labelText: S.of(context).code,
                      border: const OutlineInputBorder(),
                      icon: const Icon(Icons.pin),
                    ),
                    textInputAction:
                        (Theme.of(context).platform == TargetPlatform.iOS
                            ? TextInputAction.continueAction
                            : TextInputAction.go),
                    onEditingComplete: goOn,
                  ),
                ],
              ),
            ),
            actions: [
              SmsButton2Fa(account.vk, e),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: Text(
                  S.of(context).cancel,
                ),
              ),
              TextButton(
                onPressed: goOn,
                child: Text(
                  S.of(context).ok,
                ),
              ),
            ],
          );
        },
      );

      if (result == null) throw lang.twofa_failed;
      return VKGetValidationResult(true, code: result);
    };

    _current = account;
  }
}

class VKGetTokenData {
  VKGetTokenData(this.token, this.userId, this.expireDate);

  final String token;
  final int userId;
  final DateTime expireDate;

  @override
  String toString() => '[TOKEN $token for ID$userId, expires $expireDate]';
}

class SmsButton2Fa extends StatefulWidget {
  const SmsButton2Fa(this.client, this.error, {super.key});
  final VKGet client;
  final Map<String, dynamic> error;

  @override
  SmsButton2FaState createState() => SmsButton2FaState();
}

class SmsButton2FaState extends State<SmsButton2Fa> {
  FToast? toast;

  @override
  void initState() {
    super.initState();
    toast = FToast();
    toast!.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        try {
          await widget.client.call(
            'auth.validatePhone',
            <String, dynamic>{
              'sid': widget.error['validation_sid'],
            },
          );
          if (!mounted) return;
          FocusScope.of(context).requestFocus(FocusNode());
          toast!.showToast(
            child: statusToast(
              context: context,
              type: StatusToastType.success,
              leading: const Icon(Icons.done_rounded),
              child: Text(S.of(context).twofa_code_sent),
            ),
          );
        } catch (e) {
          FocusScope.of(context).requestFocus(FocusNode());
          if (e is Map<String, dynamic>) {
            if (e['error']['error_code'] == 1112 ||
                e['error']['error_code'] == 103) {
              toast!.showToast(
                child: statusToast(
                  context: context,
                  type: StatusToastType.error,
                  leading: const Icon(Icons.close_rounded),
                  child: Text(S.of(context).twofa_codes_too_often),
                ),
              );
              return;
            }

            toast!.showToast(
              child: statusToast(
                context: context,
                type: StatusToastType.error,
                leading: const Icon(Icons.close_rounded),
                child: Text(e['error_description'] as String),
              ),
            );
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).error)),
          );
          rethrow;
        }
      },
      child: Text(
        S.of(context).sms,
      ),
    );
  }
}
