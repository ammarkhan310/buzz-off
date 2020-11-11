import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'biteDB_util.dart';
import 'bite.dart';

// handles bloc logic
class BiteListBLoC with ChangeNotifier {
  List<Bite> biteList = [];

  // gets all bite data from sql and makes a bite list then notifies other compentents of change
  Future<List<Bite>> getAllBites() async{
    final db = await DBUtils.init();
    final List<Map<String, dynamic>> maps = await db.query('biteList'); // converts sql db data into map
    print('getting all bites...');

    List<Bite> result = [];

    // converts map data to bite object and adds it to results list for every entry in the db
    if(maps.length > 0){
      for(int i = 0; i < maps.length; i++){
        result.add(Bite.fromMap(maps[i]));
      }
    }

    // set bite list to result and notifies listeners 
    biteList = result;
    notifyListeners();

    print('getting bites complete');

    return result;
  }

  
  // inserts a new bite into the database and the list
  Future<void> insertBite(Bite newBite) async{
    biteList.add(newBite); // adds new bite to list
    final db = await DBUtils.init();
    print('inserting new bite ${newBite}');

    // convert bite to map then add to database
    await db.insert(
      'biteList',
      newBite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print('inserted bite');

    notifyListeners();
  }

  // updates a selected bite in the database
  Future<void> updateBite(Bite bite) async {
      final db = await DBUtils.init();
      biteList[biteList.indexWhere((element) => element.id == bite.id)] = bite;
      print('Updating bite id: ${bite.id} with ${bite}');

      await db.update(
        'biteList',
        bite.toMap(),
        where: 'id = ?',
        whereArgs: [bite.id],
    );

    print('Update complete');
    notifyListeners();
  }

  // wipes the database
  Future<void> deleteAllBites() async{
    biteList = []; // clears the bite list
    final db = await DBUtils.init();
    print('deleting all bites...');

    // delete all entries
    await db.delete( 
      'biteList',
    );

    print('all bites deleted');
    notifyListeners(); // notify listeners 
  }

  // removes a selected bite from list
  Future<void> deleteBite(Bite bite) async {
    biteList.remove(bite); // removes bite from list
    final db = await DBUtils.init();
    print('deleting bite: ${bite}');

    await db.delete(
      'biteList',
      where: 'id = ?',
      whereArgs: [bite.id],
    );

    print('Deleted bite: ${bite}');
    notifyListeners(); // notify listeners
  }

}