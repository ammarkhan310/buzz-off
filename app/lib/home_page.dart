/*
* Home page's layout widgets and appearance values
*/

import 'package:app/mosquito_model/mosquito_info.dart';
import 'package:app/weather_api/weather_info.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:app/mosquito_model/mosquito_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/weather_api/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong/latlong.dart';
import 'package:app/mapPage.dart';
import 'package:app/rating.dart';

class ExampleViewModel {
  final CustomSliderColors sliderColors;
  final CircularSliderAppearance appearance;
  final double min;
  final double max;
  final double value;

  ExampleViewModel({
    @required this.sliderColors,
    @required this.appearance,
    this.min = 0,
    this.max = 10,
    this.value = 1,
  });
}

class HomePage extends StatefulWidget {
  final String apiKey = '9a5b29b67deeee8118ff67d1c94ebaf8';

  final ExampleViewModel viewModel =
      ExampleViewModel(sliderColors: customColors, appearance: appearance);

  HomePage({
    Key key,
    viewModel,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

/*
 * Class containing home pages:
 * Weather description
 * Mosquito slider which indicates the mosquito level
 * User location string
 */
class _HomePageState extends State<HomePage> {
  List<WeatherInfo> weatherInfo;
  String city = 'Oshawa';
  String prov = 'ON';
  LatLng latLng;

  @override
  void initState() {
    _updateLocationOneTime();
    init();
  }

  @override
  Widget build(BuildContext context) {
    Geolocator.checkPermission();
    return Scaffold(
      body: Stack(
        children: [
          /*
          FlatButton(
            onPressed: () async {
              List<WeatherInfo> info = await loadApiInfo();
              for (var item in info) {
                print(item.toString());
              }
            },
            child: Text('Load api info'),
          ),

          Align(
            alignment: Alignment.topRight,
            child: FlatButton(
              onPressed: () {
                setState(() {});
              },
              child: Text('Refresh page'),
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: FlatButton(
              onPressed: () {
                _updateLocationOneTime();
              },
              child: Text('Check location'),
            ),
          ),
          */
          /*Label for the text box containinig the weather conditions summary
          * of the current location
          */
          Center(
            child: Container(
              height: 525,
              width: 250,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Weather Conditions:',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                      color: Colors.grey),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 500,
              width: 250,
              child: Align(
                alignment: Alignment.topCenter,
                child: getLocationWeather(),
              ),
            ),
          ),
          //Build mosquito slider containing the current rating for the location
          Center(child: getMosquitoSlider()),
          //Image of a mosquito displayed inside the ratings slider
          Center(
            child: Container(
              height: 175,
              width: 175,
              child: Align(
                alignment: Alignment.topCenter,
                child: Image(
                  image: AssetImage('assets/mosquito.png'),
                  height: 45,
                  width: 45,
                ),
              ),
            ),
          ),
          //Text displaying the ratings location
          Center(
            child: Container(
              height: 250,
              width: 300,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: getRatingLocation(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void init() async {
    print("initializing");
    weatherInfo = await loadApiInfo();

    Rating rating = Rating(latLng);

    _insertMosquitoData(MosquitoInfo(
        location: weatherInfo[0].city,
        weather: weatherInfo[0].weather,
        rating: rating.calculateRating(weatherInfo[0])));

    rating.toString();

    setState(() {});
  }

  void _updateLocationOneTime() {
    print('update location');
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position userLocation) async {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          userLocation.latitude, userLocation.longitude);

      setState(() {
        city = placemarks[0].locality;
        latLng = LatLng(userLocation.latitude, userLocation.longitude);
        init();
        print('City: ' + city);
      });
    });
  }

  Future<List<WeatherInfo>> loadApiInfo() async {
    List<WeatherInfo> info = await Weather().loadWeather(city, widget.apiKey);

    return info;
  }

  //TODO - Finish inserting data from weather api
  void _insertMosquitoData(MosquitoInfo info) {
    print("Inserting ${info.toString()} into mosquito-info collection");
    MosquitoDb().insertMosquitoData(info);
  }

  /*Retrieve the built location weather description for the home page with 
  * recent db values */
  FutureBuilder<QuerySnapshot> getLocationWeather() {
    print('Building home page location weather text with cloud-db instance');

    return FutureBuilder<QuerySnapshot>(
      future: MosquitoDb().getMosquitoInfo(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return _buildLocationWeather(snapshot.data.docs.last);
        }
      },
    );
  }

  //Build the locatiion weather description for homepage with recent db values
  Widget _buildLocationWeather(DocumentSnapshot mosquitoInfoData) {
    //Parse cloud database data
    MosquitoInfo mosquitoInfo = MosquitoInfo.fromMap(mosquitoInfoData.data(),
        docReference: mosquitoInfoData.reference.toString());

    return Text(
      '\n ${mosquitoInfo.weather}',
      style: TextStyle(
          fontStyle: FontStyle.italic, fontSize: 14, color: Colors.grey),
    );
  }

  //Retrieve the built location text for the home page with recent db values
  FutureBuilder<QuerySnapshot> getRatingLocation() {
    print('Building home page rating location text with cloud-db instance');

    return FutureBuilder<QuerySnapshot>(
      future: MosquitoDb().getMosquitoInfo(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return _buildLocationText(snapshot.data.docs.last);
        }
      },
    );
  }

  //Build the locatiion text for the home page with recent db values
  Widget _buildLocationText(DocumentSnapshot mosquitoInfoData) {
    MosquitoInfo mosquitoInfo = MosquitoInfo.fromMap(mosquitoInfoData.data(),
        docReference: mosquitoInfoData.reference.toString());

    print('Location: ${mosquitoInfo.location}');
    return FlatButton(
        onPressed: () async {
          final String newLoc = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MapPage(
                title: 'Find Location',
                latLng: latLng,
              ),
            ),
          );

          var info = MosquitoInfo(
              weather: weatherInfo[0].weather, location: newLoc, rating: 6);
          _insertMosquitoData(info);
          getRatingLocation();
          setState(() {});
        },
        color: Colors.black.withOpacity(0.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.green)),
        child: Text(
          'Location: ${mosquitoInfo.location}',
          style: TextStyle(
              fontStyle: FontStyle.italic, fontSize: 18, color: Colors.grey),
        ));
  }

  //Retrieve the built mosquito slider for the home page with recent db values
  FutureBuilder<QuerySnapshot> getMosquitoSlider() {
    print('Building home page mosquito slider with cloud-db instance');

    return FutureBuilder<QuerySnapshot>(
      future: MosquitoDb().getMosquitoInfo(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          return Center(
            child: _buildSlider(
                widget.viewModel.sliderColors,
                widget.viewModel.appearance,
                widget.viewModel.min,
                widget.viewModel.max,
                snapshot.data.docs.last),
          );
        }
      },
    );
  }

  //Build the mosquito rating slider for the home page with recent db values
  Widget _buildSlider(
      CustomSliderColors sliderColor,
      CircularSliderAppearance appearance,
      double min,
      double max,
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

//Width values for the home pages mosquito level slider
final customWidth =
    CustomSliderWidths(trackWidth: 0, progressBarWidth: 20, shadowWidth: 25);

//Custom color values for the home pages mosquito level slider
final customColors = CustomSliderColors(
    dotColor: Colors.white.withOpacity(0.8),
    trackColor: HexColor('#000000').withOpacity(0.0),
    progressBarColors: [
      HexColor('#993333').withOpacity(0.9),
      HexColor('#FFCC00').withOpacity(0.9),
      HexColor('#33CC33').withOpacity(0.9),
    ],
    shadowColor: HexColor('#4C4C4C').withOpacity(0.8),
    shadowMaxOpacity: 0.08);

//Information text values for the home pages mosquito level slider
final info = InfoProperties(
  mainLabelStyle:
      TextStyle(color: Colors.black, fontSize: 60, fontWeight: FontWeight.w300),
  bottomLabelStyle:
      TextStyle(color: Colors.black, fontSize: 15, fontStyle: FontStyle.italic),
  //Modify default text percentage values to remove percent symbol
  modifier: (double value) {
    final modValue = value.toInt();
    return '$modValue';
  },
  bottomLabelText: 'Mosquito Level',
);

//Appearance values for home pages mosquito slider
final CircularSliderAppearance appearance = CircularSliderAppearance(
    customWidths: customWidth,
    customColors: customColors,
    infoProperties: info,
    startAngle: 160,
    angleRange: 220,
    size: 280.0);
