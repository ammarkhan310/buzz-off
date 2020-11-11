class Bite{
  int id;
  DateTime dateBitten;
  int size; //0-9 bite serverity
  String location; //location of bite
  String imageURL;

  Bite(DateTime dateBitten, int size, String location){
    this.dateBitten = dateBitten;
    this.size = size;
    this.location = location;
    imageURL = 'assets/bitemap/' + '$location' + 'Bite.png'; // takes location and creates a imageURL
  }

  // constructs BiteHistory object from map
  Bite.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.dateBitten = DateTime.parse(map['dateBitten']); // parse string to DateTime format
    this.size = map['size'];
    this.location = map['location'];
    this.imageURL = map['imageURL'];
  }

  // converts BiteHistory object to map
  Map<String, dynamic> toMap(){
    return{
      'id' : this.id,
      'dateBitten' : '${this.dateBitten}',
      'size' : this.size,
      'location' : this.location,
      'imageURL' : this.imageURL,
    };
  }

  String toString() {
    return 'BiteHistory{ID: $id, dateBitten: $dateBitten, Size: $size, location: $location, ImageURL: $imageURL}';
  }
}