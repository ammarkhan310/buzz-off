import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/mosquito_model/mosquito_info.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class MosquitoDb {
  String _selectedType = 'All';

  CollectionReference getDbInstance() {
    print("Getting mosquito-info collection");
    return FirebaseFirestore.instance.collection('mosquito-info');
  }

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

  Future<QueryDocumentSnapshot> getLastDoc() async {
    var snapshot;
    await getMosquitoInfo().then((value) => snapshot = value);
    return snapshot.docs.first;
  }

  Future<List<String>> getInfoList() async {
    List<String> infoList = [];
    var mosquitoInfoData = await getLastDoc();
    MosquitoInfo mosquitoInfo = MosquitoInfo.fromMap(mosquitoInfoData.data(),
        docReference: mosquitoInfoData.reference.toString());
    infoList.add(mosquitoInfo.location);
    infoList.add(mosquitoInfo.rating.toString());
    infoList.add(mosquitoInfo.weather);
    return infoList;
  }

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

  void insertMosquitoData(MosquitoInfo info) async {
    CollectionReference db = getDbInstance();
    await db.doc(info.docReference.toString()).set(info.toMap(info));
  }

  Widget _buildLocationText(DocumentSnapshot mosquitoInfoData) {
    MosquitoInfo mosquitoInfo = MosquitoInfo.fromMap(mosquitoInfoData.data(),
        docReference: mosquitoInfoData.reference.toString());
    return Text(
      'Location: ${mosquitoInfo.location}',
      style: TextStyle(
          fontStyle: FontStyle.italic, fontSize: 10, color: Colors.grey),
    );
  }

  Widget _buildLocationWeather(DocumentSnapshot mosquitoInfoData) {
    MosquitoInfo mosquitoInfo = MosquitoInfo.fromMap(mosquitoInfoData.data(),
        docReference: mosquitoInfoData.reference.toString());
    return Text(
      '\n ${mosquitoInfo.weather}',
      style: TextStyle(
          fontStyle: FontStyle.italic, fontSize: 10, color: Colors.grey),
    );
  }

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
