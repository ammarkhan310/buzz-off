import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/mosquito_model/mosquito_info.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class MosquitoDb {
  String _selectedType = 'All';

  Future<QuerySnapshot> getMosquitoInfo() async {
    if (_selectedType == 'All') {
      return await FirebaseFirestore.instance.collection('mosquito-info').get();
    } else {
      return await FirebaseFirestore.instance
          .collection('mosquito-info')
          .where('type', isEqualTo: _selectedType)
          .get();
    }
  }

  FutureBuilder<QuerySnapshot> getMosquitoData(
      BuildContext context,
      CustomSliderColors sliderColor,
      CircularSliderAppearance appearance,
      double min,
      double max) {
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

  Widget _buildSlider(
      CustomSliderColors sliderColor,
      CircularSliderAppearance appearance,
      double min,
      double max,
      BuildContext context,
      DocumentSnapshot mosquitoInfoData) {
    MosquitoInfo mosquitoInfo = MosquitoInfo.fromMap(mosquitoInfoData.data(),
        reference: mosquitoInfoData.reference);
    return SleekCircularSlider(
      appearance: appearance,
      min: min,
      max: max,
      initialValue: mosquitoInfo.rating.toDouble(),
    );
  }
}
