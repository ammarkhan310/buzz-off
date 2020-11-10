import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils {
  // opens the database if it exist else creates one
  static Future<Database> init() async{
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'biteList.db'),

      onCreate: (db, version){
        db.execute('CREATE TABLE biteList(id INTEGER PRIMARY KEY, dateBitten TEXT, size INTEGER, location TEXT, imageURL TEXT)');
      },
      version: 1,
    );
    return database;
  }
}