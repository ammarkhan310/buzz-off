import 'package:cloud_firestore/cloud_firestore.dart';

class MosquitoInfo {
  String location;
  String weather;
  int rating;
  DocumentReference reference;

  MosquitoInfo.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.location = map['location'];
    this.weather = map['weather'];
    this.rating = map['rating'];
  }
}
