import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/mosquito_model/mosquito_info.dart';

class MosquitoDb {
  String _selectedType = 'All';

  //Retrieve an instance of the database
  CollectionReference getDbInstance() {
    print("Getting mosquito-info collection");

    return FirebaseFirestore.instance.collection('mosquito-info');
  }

  //Recieve an instance of queried information selected by _selectedType
  Future<QuerySnapshot> getMosquitoInfo() async {
    print("Returning info on all queried selected mosquito types");

    if (_selectedType == 'All') {
      return await FirebaseFirestore.instance.collection('mosquito-info').get();
    } else {
      return await FirebaseFirestore.instance
          .collection('mosquito-info')
          .where('type', isEqualTo: _selectedType)
          .get();
    }
  }

  /*Retrieve the first doc on the stack of documents used as the recent mosuqito 
  * location currently */
  Future<QueryDocumentSnapshot> getLastLocationInfo() async {
    var snapshot;

    await getMosquitoInfo().then((value) => snapshot = value);

    return snapshot.docs.first;
  }

  /* Get a list of information from the first document with it values 
  * (location, rating, weather) */
  Future<List<String>> getInfoList() async {
    List<String> infoList = [];

    var mosquitoInfoData = await getLastLocationInfo();

    MosquitoInfo mosquitoInfo = MosquitoInfo.fromMap(mosquitoInfoData.data(),
        docReference: mosquitoInfoData.reference.toString());

    infoList.add(mosquitoInfo.location);
    infoList.add(mosquitoInfo.rating.toString());
    infoList.add(mosquitoInfo.weather);

    return infoList;
  }

  //Insert values into the cloud database instance
  void insertMosquitoData(MosquitoInfo info) async {
    CollectionReference db = getDbInstance();

    await db.doc(info.docReference.toString()).set(info.toMap(info));
  }
}
