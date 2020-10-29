/*
* Home page's layout widgets and appearance values
*/

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SleekCircularSlider(
              //TODO - Insert mosquito levels here
              onChangeStart: (double value) {},
              onChangeEnd: (double value) {},

              appearance: widget.viewModel.appearance,
              min: widget.viewModel.min,
              max: widget.viewModel.max,
              initialValue: widget.viewModel.value,
            ),
          ),
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

          //TODO - Insert User's saved locations
          //TODO - Make the text clickable
          Center(
            child: Container(
              height: 250,
              width: 300,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Location: Insert user's saved location",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ),

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
                      fontSize: 10,
                      color: Colors.grey),
                ),
              ),
            ),
          ),

          //TODO - Input weather conditions based on weather variables
          Center(
            child: Container(
              height: 500,
              width: 250,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit,'
                  'sed do eiusmod tempor incididunt ut labore et dolore magna'
                  'aliqua. Ut enim ad minim veniam, quis nostrud exercitation'
                  'ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 10,
                      color: Colors.grey),
                ),
              ),
            ),
          )
        ],
      ),
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
