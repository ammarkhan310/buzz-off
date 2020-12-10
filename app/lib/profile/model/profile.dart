import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'profileDB_utils.dart';
import 'dart:async';

// Profile Model Definition
class Profile {
  // Constructor
  Profile({
    this.id,
    this.name,
    this.gender,
    this.bloodType,
    this.country,
    this.dob,
  });

  int id;
  String name;
  String gender;
  String bloodType;
  String country;
  String dob;

  // Assigns values from input map to objects variables
  Profile.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.gender = map['gender'];
    this.bloodType = map['bloodType'];
    this.country = map['country'];
    this.dob = map['dob'];
  }

  // Maps the respective values of the profile to an output map
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'gender': this.gender,
      'bloodType': this.bloodType,
      'country': this.country,
      'dob': this.dob,
    };
  }

  
  String toString(){
    return(name);
  }
}

// Profile Model Class used to modify values in local database
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

  // Fetches one profile instance based on it's id key
  Future<Profile> getProfileById(int id) async {
    final db = await DBUtils.init();
    List<Map<String, dynamic>> maps = await db.query(
      'profiles',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return Profile.fromMap(maps[0]);
    } else {
      return null;
    }
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

  // Updates a profile in the database
  Future<int> updateProfile(Profile profile) async {
    final db = await DBUtils.init();
    final updatedProfile = await db.update(
      'profiles',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
    notifyListeners();
    return updatedProfile;
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
