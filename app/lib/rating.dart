import 'package:app/weather_api/weather_info.dart';

class Rating {
  int ratingValue;
  String weather;
  String date;
  String location;
  int humidity;
  int rain;

  int calculateRating(WeatherInfo info) {
    print('Calculating Rating');
    this.weather = info.weather;
    this.humidity = info.humidity;
    this.rain = info.rain;

    if (rain != null) {
      ratingValue += 3;
    }

    if (humidity != null) {
      ratingValue += ((humidity / 10) ~/ 3);
    }

    return ratingValue;
  }

  String toString() {
    return 'Weather: $weather, Humidity: $humidity, Rain: $rain';
  }
}
