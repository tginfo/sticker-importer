import 'dart:async';

import 'package:idb_sqflite/idb_sqflite.dart';
import '../db/db_keeper.dart';

class _BroadcastingStream<T> {
  _BroadcastingStream(this.controller, this.stream);
  final StreamController<T> controller;
  final Stream<T> stream;
}

class SettingNotFoundException implements Exception {
  const SettingNotFoundException(String name)
      : message = "Couldn't retrieve $name setting";

  final String message;
  @override
  String toString() => message;
}

class SettingsStorageTable {
  SettingsStorageTable(this.name);

  final String name;

  Future<T> get<T>(String key) async {
    var data = await (await SettingsStorage._database.readTransaction(name))
        .getObject(key);

    dynamic v;

    if (data != null) {
      data = data as Map;

      v = data['value'];
    } else {
      v = getDefault(name, key);
    }

    if (v is T) {
      return v;
    }

    throw SettingNotFoundException(key);
  }

  Future<void> set<T>(String key, T value) async {
    await (await SettingsStorage._database.writeTransaction(name))
        .put(<String, dynamic>{'key': key, 'value': value});

    Timer.run(() async {
      if (_changesStreams.containsKey(key)) {
        final broadcast = _changesStreams[key];
        broadcast!.controller.add(await get<T>(key));
      }
    });
  }

  Future<void> unset(String key) async {
    await (await SettingsStorage._database.writeTransaction(name)).delete(key);

    Timer.run(() async {
      if (_changesStreams.containsKey(key)) {
        final broadcast = _changesStreams[key];

        try {
          broadcast!.controller.add(await get<dynamic>(key));
        } on SettingNotFoundException {
          broadcast!.controller.add(null);
        }
      }
    });
  }

  Stream<T?> changes<T>(String key) {
    if (!_changesStreams.containsKey(key)) {
      // ignore: close_sinks
      final controller = StreamController<T?>();
      final stream = controller.stream.asBroadcastStream();
      _changesStreams[key] = _BroadcastingStream<T?>(controller, stream);
    }

    return _changesStreams[key]!.stream as Stream<T?>;
  }

  bool killBroadcast(String key) {
    if (_changesStreams.containsKey(key)) {
      final broadcast = _changesStreams[key];
      broadcast!.controller.close();
    }
    return false;
  }

  final Map<String, _BroadcastingStream<dynamic>> _changesStreams = {};

  static final Map<String, Map<String, dynamic>> defaults = {};

  static void setDefault<T>(String name, String key, T value) {
    var v = defaults[name];

    if (v == null) {
      final m = <String, dynamic>{};
      defaults[name] = m;
      v = m;
    }

    v[key] = value;
  }

  static dynamic getDefault(String name, String key) {
    return defaults[name]?[key];
  }
}

class SettingsStorage {
  static final DbKeeper _database = DbKeeper(
    'settings.db',
    {
      1: DbKeeperStoreChanges(
        [
          (db, version, event) async {
            db.createObjectStore('main', keyPath: 'key');
            db.createObjectStore('activity', keyPath: 'key');
            db.createObjectStore('flags', keyPath: 'key');
          }
        ],
      ),
    },
  );

  static SettingsStorageTable of(String name) {
    if (!tablesCache.containsKey(name)) {
      tablesCache[name] = SettingsStorageTable(name);
    }

    return tablesCache[name]!;
  }

  static final Map<String, SettingsStorageTable> tablesCache = {};

  static Future<Database> Function() get init => _database.init;
}

class TypeConvert {
  static int strToInt(String str) {
    return int.parse(str);
  }

  static String intToStr(int n) {
    return n.toString();
  }

  static double strToDouble(String str) {
    return double.parse(str);
  }

  static String doubleToString(double n) {
    return n.toString();
  }

  static bool strToBool(String str) {
    return str == '1';
  }

  static String boolToStr(bool b) {
    return b ? '1' : '0';
  }
}
