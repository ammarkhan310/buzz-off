import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'db_utils.dart';

// Profile Model Definition
class Profile {
  // Constructor
  Profile({this.name, this.gender, this.bloodType, this.age, this.country});

  int id;
  String name;
  String gender;
  String bloodType;
  String age;
  String country;

  // Assigns values from input map to objects variables
  Profile.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.gender = map['gender'];
    this.bloodType = map['bloodType'];
    this.age = map['age'];
    this.country = map['country'];
  }

  // Maps the respective values of the profile to an output map
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'gender': this.gender,
      'bloodType': this.bloodType,
      'age': this.age,
      'country': this.country,
    };
  }
}

// Profile Model Class used to modify values in database
class ProfileModel with ChangeNotifier {
  // Fetches all Profile Objects in Database
  Future<List<Profile>> getAllProfiles() async {
    final db = await DBUtils.init();
    List<Map<String, dynamic>> maps = await db.query('profiles');
    List<Profile> profiles = [];
    for (int i = 0; i < maps.length; i++) {
      profiles.add(Profile.fromMap(maps[i]));
    }
    return profiles;
  }

  // Adds a new Profile Object to the Database
  Future<int> insertProfile(Profile address) async {
    final db = await DBUtils.init();
    final newProfile = await db.insert(
      'profiles',
      address.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // Ensures that the new profile is reflected in the profile list
    notifyListeners();
    return newProfile;
  }

  // Deletes Profile with a given id
  Future<int> deleteProfileWithId(int id) async {
    final db = await DBUtils.init();
    final deletedProfile = await db.delete(
      'profiles',
      where: 'id = ?',
      whereArgs: [id],
    );
    // Ensures that the changes made are reflected in the profile list
    notifyListeners();
    return deletedProfile;
  }

  // Deletes all profiles from the database
  Future<int> deleteAllProfiles() async {
    final db = await DBUtils.init();
    final deletedProfiles = await db.delete(
      'profiles',
    );
    // Ensures that the changes made are reflected in the profile list
    notifyListeners();
    return deletedProfiles;
  }
}
