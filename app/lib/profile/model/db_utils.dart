import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

// Class used to initialize Database using SQLite
class DBUtils {
  static Future<Database> init() async {
    return openDatabase(
      path.join(await getDatabasesPath(), 'buzzOff.db'),
      onCreate: (db, version) async {
        if (version > 1) {
          // downgrade path
        }
        await db.execute(
            'CREATE TABLE address(id INTEGER PRIMARY KEY, address TEXT, ' +
                'city TEXT, state TEXT, postalCode TEXT, country TEXT)');
        await db.execute(
            'CREATE TABLE profiles(id INTEGER PRIMARY KEY, name TEXT, ' +
                'gender TEXT, bloodType TEXT, age TEXT, country TEXT)');
      },
      version: 1,
    );
  }
}
