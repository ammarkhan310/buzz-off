import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class ExampleViewModel {
  final CustomSliderColors pageColors;
  final CircularSliderAppearance appearance;
  final double min;
  final double max;
  final double value;
  final InnerWidget innerWidget;

  ExampleViewModel(
      {@required this.pageColors,
      @required this.appearance,
      this.min = 0,
      this.max = 10,
      this.value = 1,
      this.innerWidget});
}

class HomeSlider extends StatefulWidget {
  final ExampleViewModel viewModel =
      ExampleViewModel(pageColors: customColors01, appearance: appearance01);

  HomeSlider({
    Key key,
    viewModel,
  }) : super(key: key);

  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: SleekCircularSlider(
            //Enable slider for testing purposes
            onChangeStart: (double value) {},
            onChangeEnd: (double value) {},

            innerWidget: widget.viewModel.innerWidget,
            appearance: widget.viewModel.appearance,
            min: widget.viewModel.min,
            max: widget.viewModel.max,
            initialValue: widget.viewModel.value,
          ),
        ),
      ),
    );
  }
}

final customWidth01 =
    CustomSliderWidths(trackWidth: 2, progressBarWidth: 20, shadowWidth: 50);

final customColors01 = CustomSliderColors(
    dotColor: Colors.white.withOpacity(0.8),
    trackColor: HexColor('#000000').withOpacity(0.6),
    progressBarColors: [
      HexColor('#993333').withOpacity(0.9),
      HexColor('#FFCC00').withOpacity(0.9),
      HexColor('#33CC33').withOpacity(0.9),
    ],
    shadowColor: HexColor('#FFD7E2'),
    shadowMaxOpacity: 0.08);

final info = InfoProperties(
    mainLabelStyle: TextStyle(
        color: Colors.black, fontSize: 60, fontWeight: FontWeight.w300),
    modifier: (double value) {
      final modValue = value.toInt();
      return '$modValue';
    });

final CircularSliderAppearance appearance01 = CircularSliderAppearance(
    customWidths: customWidth01,
    customColors: customColors01,
    infoProperties: info,
    startAngle: 180,
    angleRange: 180,
    size: 250.0);
