import 'package:flutter/material.dart';
import 'dart:async';
import 'profileDB_utils.dart';

// ActiveUser Model Definition
class ActiveUser {
  // Constructor
  ActiveUser({
    this.id,
    this.profileId,
  });

  int id;
  int profileId;

  // Assigns values from input map to objects variables
  ActiveUser.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.profileId = map['profileId'];
  }

  // Maps the respective values of the address to an output map
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'profileId': this.profileId,
    };
  }
}

// ActiveUser Model Class used to modify values in database
class ActiveUserModel with ChangeNotifier {
  // Fetches the current active user profile
  Future<ActiveUser> getActiveUserId() async {
    final db = await DBUtils.init();
    List<Map<String, dynamic>> maps = await db.query(
      'active_profile',
      where: 'id = ?',
      whereArgs: [1],
    );

    if (maps.length > 0) {
      return ActiveUser.fromMap(maps[0]);
    } else {
      return null;
    }
  }

  // Updates the current active user profile
  Future<int> updateActiveUser(int profileId) async {
    final db = await DBUtils.init();
    final updatedAddress = await db.update(
      'active_profile',
      {
        'id': 1,
        'profileId': profileId,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
    notifyListeners();
    return updatedAddress;
  }
}
