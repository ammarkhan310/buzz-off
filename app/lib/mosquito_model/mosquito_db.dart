import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/mosquito_model/mosquito_info.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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
  Future<QueryDocumentSnapshot> getFirstDoc() async {
    var snapshot;
    await getMosquitoInfo().then((value) => snapshot = value);
    return snapshot.docs.first;
  }

  /* Get a list of information from the first document with it values 
  * (location, rating, weather) */
  Future<List<String>> getInfoList() async {
    List<String> infoList = [];
    var mosquitoInfoData = await getFirstDoc();
    MosquitoInfo mosquitoInfo = MosquitoInfo.fromMap(mosquitoInfoData.data(),
        docReference: mosquitoInfoData.reference.toString());
    infoList.add(mosquitoInfo.location);
    infoList.add(mosquitoInfo.rating.toString());
    infoList.add(mosquitoInfo.weather);
    return infoList;
  }

  //Retrieve the built mosquito slider for the home page with recent db values
  FutureBuilder<QuerySnapshot> getMosquitoSlider(
      BuildContext context,
      CustomSliderColors sliderColor,
      CircularSliderAppearance appearance,
      double min,
      double max) {
    print('Building home page mosquito slider with cloud-db instance');
    return FutureBuilder<QuerySnapshot>(
      future: getMosquitoInfo(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          return Center(
            child: _buildSlider(sliderColor, appearance, min, max, context,
                snapshot.data.docs.first),
          );
        }
      },
    );
  }

  //Retrieve the built location text for the home page with recent db values
  FutureBuilder<QuerySnapshot> getRatingLocation(BuildContext context) {
    print('Building home page rating location text with cloud-db instance');
    return FutureBuilder<QuerySnapshot>(
      future: getMosquitoInfo(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return _buildLocationText(snapshot.data.docs.first);
        }
      },
    );
  }

  /*Retrieve the built location weather description for the home page with 
  * recent db values */
  FutureBuilder<QuerySnapshot> getLocationWeather(BuildContext context) {
    print('Building home page location weather text with cloud-db instance');
    return FutureBuilder<QuerySnapshot>(
      future: getMosquitoInfo(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return _buildLocationWeather(snapshot.data.docs.first);
        }
      },
    );
  }

  //Insert values into the cloud database instance
  void insertMosquitoData(MosquitoInfo info) async {
    CollectionReference db = getDbInstance();
    await db.doc(info.docReference.toString()).set(info.toMap(info));
  }

  //Build the locatiion text for the home page with recent db values
  Widget _buildLocationText(DocumentSnapshot mosquitoInfoData) {
    MosquitoInfo mosquitoInfo = MosquitoInfo.fromMap(mosquitoInfoData.data(),
        docReference: mosquitoInfoData.reference.toString());
    return Text(
      'Location: ${mosquitoInfo.location}',
      style: TextStyle(
          fontStyle: FontStyle.italic, fontSize: 10, color: Colors.grey),
    );
  }

  //Build the locatiion weather description for homepage with recent db values
  Widget _buildLocationWeather(DocumentSnapshot mosquitoInfoData) {
    MosquitoInfo mosquitoInfo = MosquitoInfo.fromMap(mosquitoInfoData.data(),
        docReference: mosquitoInfoData.reference.toString());
    return Text(
      '\n ${mosquitoInfo.weather}',
      style: TextStyle(
          fontStyle: FontStyle.italic, fontSize: 10, color: Colors.grey),
    );
  }

  //Build the mosquito rating slider for the home page with recent db values
  Widget _buildSlider(
      CustomSliderColors sliderColor,
      CircularSliderAppearance appearance,
      double min,
      double max,
      BuildContext context,
      DocumentSnapshot mosquitoInfoData) {
    MosquitoInfo mosquitoInfo = MosquitoInfo.fromMap(mosquitoInfoData.data(),
        docReference: mosquitoInfoData.reference.toString());
    return SleekCircularSlider(
      appearance: appearance,
      min: min,
      max: max,
      initialValue: mosquitoInfo.rating.toDouble(),
    );
  }
}
