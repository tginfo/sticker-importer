import 'package:flutter/material.dart';
import 'package:sticker_import/services/connection/account.dart';

class AccountData extends InheritedWidget {
  const AccountData({
    required this.account,
    required super.child,
    super.key,
  });

  final Account account;

  static AccountData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AccountData>();
  }

  @override
  bool updateShouldNotify(AccountData oldWidget) =>
      account != oldWidget.account;
}
