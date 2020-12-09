import 'dart:collection';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/weather_api/weather_info.dart';

class Weather {
  Future<List<WeatherInfo>> loadWeather(String city, String apiKey) async {
    List<WeatherInfo> weatherInfo;

    var response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey');

    if (response.statusCode == 200) {
      weatherInfo = [];
      Map<String, dynamic> infoItems = jsonDecode(response.body);
      weatherInfo.add(WeatherInfo.fromMap(infoItems));
    }

    return weatherInfo;
  }
}
