import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'db_utils.dart';

// Address Model Definition
class Address {
  // Constructor
  Address({this.address, this.city, this.state, this.postalCode, this.country});

  int id;
  String address;
  String city;
  String state;
  String postalCode;
  String country;

  // Assigns values from input map to objects variables
  Address.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.address = map['address'];
    this.city = map['city'];
    this.state = map['state'];
    this.postalCode = map['postalCode'];
    this.country = map['country'];
  }

  // Maps the respective values of the address to an output map
  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'address': this.address,
      'city': this.city,
      'state': this.state,
      'postalCode': this.postalCode,
      'country': this.country,
    };
  }
}

// Address Model Class used to modify values in database
class AddressModel with ChangeNotifier {
  // Fetches all Address Objects in Database
  Future<List<Address>> getAllAddresses() async {
    final db = await DBUtils.init();
    List<Map<String, dynamic>> maps = await db.query('address');
    List<Address> addresses = [];
    for (int i = 0; i < maps.length; i++) {
      addresses.add(Address.fromMap(maps[i]));
    }
    return addresses;
  }

  // Fetches one address instance based on it's id key
  Future<Address> getAddressWithId(String id) async {
    final db = await DBUtils.init();
    List<Map<String, dynamic>> maps = await db.query(
      'address',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return Address.fromMap(maps[0]);
    } else {
      return null;
    }
  }

  // Adds a new Address Object to the Database
  Future<int> insertAddress(Address address) async {
    final db = await DBUtils.init();
    final newAddress = await db.insert(
      'address',
      address.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // Ensures that new address is reflected on the address list
    notifyListeners();
    return newAddress;
  }

  // Updates an address in the database
  Future<int> updateAddress(Address address) async {
    final db = await DBUtils.init();
    final updatedAddress = await db.update(
      'address',
      address.toMap(),
      where: 'id = ?',
      whereArgs: [address.id],
    );
    notifyListeners();
    return updatedAddress;
  }

  // Deletes Address with a given ID
  Future<int> deleteAddressWithId(int id) async {
    final db = await DBUtils.init();
    final deletedAddress = await db.delete(
      'address',
      where: 'id = ?',
      whereArgs: [id],
    );
    // Ensures that the changes made are reflected in the address list
    notifyListeners();
    return deletedAddress;
  }

  // Deletes all addresses from the database
  Future<int> deleteAllAddresses() async {
    final db = await DBUtils.init();
    final deletedAddresses = await db.delete(
      'address',
    );
    // Ensures that the changes made are reflected in the address list
    notifyListeners();
    return deletedAddresses;
  }
}
