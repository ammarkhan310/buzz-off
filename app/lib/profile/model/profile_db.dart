import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileDb {
  String _selectedType = 'All';

  //Retrieve an instance of the database
  CollectionReference getDbInstance() {
    print("Getting profile collection");
    return FirebaseFirestore.instance.collection('profile');
  }

  //Recieve an instance of queried information selected by _selectedType
  Future<QuerySnapshot> getProfileInfo() async {
    print("Returning info on all queried selected profiles");
    if (_selectedType == 'All') {
      return await FirebaseFirestore.instance.collection('profile').get();
    } else {
      return await FirebaseFirestore.instance
          .collection('profile')
          .where('type', isEqualTo: _selectedType)
          .get();
    }
  }

  /*Retrieve the first doc on the stack of documents used as the recent profile 
  * location currently */
  Future<QueryDocumentSnapshot> getFirstDoc() async {
    var snapshot;
    await getProfileInfo().then((value) => snapshot = value);
    return snapshot.docs.first;
  }
}
