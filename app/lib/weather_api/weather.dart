import 'dart:collection';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/weather_api/weather_info.dart';
import 'package:app/settings/view/settings_page.dart';

class Weather {
  var _settingsPage = SettingsPage();

  Future<List<WeatherInfo>> loadWeather(String city, String apiKey) async {
    List<WeatherInfo> weatherInfo;

    String apiHTTP = metricOrImperial(_settingsPage.metImp());

    var response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');

    if (response.statusCode == 200) {
      weatherInfo = [];
      Map<String, dynamic> infoItems = jsonDecode(response.body);
      weatherInfo.add(WeatherInfo.fromMap(infoItems));
    }

    return weatherInfo;
  }
}

String metricOrImperial(bool metric) {
  String mOI = '';
  if (metric = true) {
    mOI =
        'https://api.openweathermap.org/data/2.5/weather?q=\$city&appid=\$apiKey&units=metric';
  } else if (metric = false) {
    mOI =
        'https://api.openweathermap.org/data/2.5/weather?q=\$city&appid=\$apiKey&units=imperial';
  }
  return mOI;
}
