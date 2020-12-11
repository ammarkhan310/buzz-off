class MosquitoInfo {
  String docReference;
  String location;
  String weather;
  int rating;

  MosquitoInfo({this.docReference, this.location, this.weather, this.rating});

  //  create mosquito from map
  MosquitoInfo.fromMap(Map<String, dynamic> map, {this.docReference}) {
    this.location = map['location'];
    this.weather = map['weather'];
    this.rating = map['rating'];
  }

  // convert mosquito from map
  Map<String, dynamic> toMap(MosquitoInfo info) {
    return {
      'location': info.location,
      'weather': info.weather,
      'rating': info.rating,
    };
  }

  // return string rep of mosquito
  String toString() {
    return ("City: $location. Weather conditions: $weather. Rating: $rating");
  }
}
