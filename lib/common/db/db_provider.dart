import 'package:shared_task_list/common/constant.dart';
import 'package:sqflite/sqflite.dart';

import 'migrations.dart';

class DBProvider {
  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDB();
    return _database!;
  }

  DBProvider._();

  Future initDB() async {
    return await openDatabase(
      Constant.dbName,
      version: 11,
      onOpen: (db) {},
      singleInstance: true,
      onCreate: (Database db, int version) async {
        initScript.forEach((script) async => await db.execute(script));
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        await migrate(db);
      },
    );
  }

  Future migrate(Database db) async {
    for (final table in tables) {
      await replaceTable(db, table);
    }
  }

  Future replaceTable(Database db, String table) async {
    List<Map<String, Object?>> maps;

    try {
      maps = await db.query(table);
    } catch (e) {
      maps = [];
    }

    final batch = db.batch();
    batch.rawDelete('drop table IF EXISTS $table');
    batch.execute(scriptMap[table]!);

    for (final m in maps) {
      batch.insert(table, m);
    }

    await batch.commit(noResult: true);
  }
}
