class MosquitoInfo {
  String docReference;
  String location;
  String weather;
  int rating;

  MosquitoInfo({this.docReference, this.location, this.weather, this.rating});

  MosquitoInfo.fromMap(Map<String, dynamic> map, {this.docReference}) {
    this.location = map['location'];
    this.weather = map['weather'];
    this.rating = map['rating'];
  }

  Map<String, dynamic> toMap(MosquitoInfo info) {
    return {
      'location': info.location,
      'weather': info.weather,
      'rating': info.rating,
    };
  }

  String toString() {
    return ("City: $location. Weather conditions: $weather. Rating: $rating");
  }
}
