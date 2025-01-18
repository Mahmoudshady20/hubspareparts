import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DbHelper {
  static Future<Database> database(String dbName) async {
    final dbpath = await sql.getDatabasesPath();

    return sql.openDatabase(path.join(dbpath, '$dbName.db'), version: 1,
        onCreate: (db, version) {
      db.execute(dbName == 'cart'
          ? 'CREATE TABLE $dbName(id INTEGER PRIMARY KEY,rowId TEXT, data LONGTEXT)'
          : 'CREATE TABLE $dbName(id INTEGER PRIMARY KEY, productId TEXT, vendorId TEXT, title TEXT NOT NULL, price DOUBLE, originalPrice DOUBLE, imgUrl TEXT, isCartable INTEGER, prodCatData TEXT, rating DOUBLE,random_key TEXT, random_secret TEXT)');
    });
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DbHelper.database(table);
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> fetchDb(String table) async {
    final db = await DbHelper.database(table);

    return db.query(table);
  }

  static Future<void> updatedb(String table, rowId, data) async {
    final db = await DbHelper.database(table);
    db.update(
      table,
      data,
      where: 'rowId = ?',
      whereArgs: [rowId],
    );
  }

  static Future<void> deleteDbTable(String table) async {
    final db = await DbHelper.database(table);
    db.delete(table);
  }

  static Future<void> deleteDbSI(String table, dynamic id) async {
    final db = await DbHelper.database(table);

    db.delete(
      table,
      where: 'productId = ?',
      whereArgs: [id],
    );
  }
}
