import 'package:path/path.dart';
import 'package:idb_sqflite/idb_sqflite.dart';
import 'package:sqflite/sqflite.dart' hide Database;

class DbKeeperStoreChanges {
  DbKeeperStoreChanges(this.query);
  final List<Future<void> Function(Database, int, VersionChangeEvent)> query;
}

class DbKeeper {
  DbKeeper(this.name, this.stores, [this.version = 1]);

  Database? database;

  final Map<int, DbKeeperStoreChanges> stores;

  final String name;
  final int version;

  Future<Database> init() async {
    database ??= await getIdbFactorySqflite(databaseFactory).open(
      join((await getDatabasesPath()), name),
      onUpgradeNeeded: (VersionChangeEvent event) async {
        final Database db = event.database;
        for (var i = 1; i <= version; i++) {
          final changes = stores[i];
          if (changes == null) continue;

          for (final q in changes.query) {
            await q(db, version, event);
          }
        }
      },
      version: version,
    );

    return database!;
  }

  Future<ObjectStore> readTransaction(String storeName) async {
    final db = await init();
    final t = db.transaction(storeName, idbModeReadOnly);
    return t.objectStore(storeName);
  }

  Future<ObjectStore> writeTransaction(String storeName) async {
    final db = await init();
    final t = db.transaction(storeName, idbModeReadWrite);
    return t.objectStore(storeName);
  }
}
