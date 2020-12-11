import 'package:app/weather_api/weather_info.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong/latlong.dart';
import 'package:daylight/daylight.dart';

class Rating {
  int ratingValue = 0;
  LatLng location;
  String weather;
  int temp;
  int humidity;
  int rain;

  Rating(this.location);

  int calculateRating(WeatherInfo info) {
    print('Calculating Rating');
    this.weather = info.weather;
    this.humidity = info.humidity;
    this.rain = info.rain;
    this.temp = info.temp;

    final timeCalculator = DaylightCalculator(
        DaylightLocation(location.latitude, location.longitude));
    final dailyResults =
        timeCalculator.calculateForDay(DateTime.now(), Zenith.astronomical);
    int eventHourEpoch = timeCalculator
        .calculateEvent(DateTime.now(), Zenith.official, EventType.sunset)
        .millisecondsSinceEpoch;

    if (rain != null) {
      ratingValue += 3;
    }

    if (humidity != null) {
      ratingValue += ((humidity / 10) ~/ 3);
    }

    if (DateTime.now().millisecondsSinceEpoch > eventHourEpoch) {
      ratingValue *= 2;
    }

    if (temp != null) {
      if (temp <= 15) {
        ratingValue = 0;
      } else if (temp > 15 && temp <= 25) {
        ratingValue = (ratingValue * 1.5).toInt();
      } else {
        ratingValue *= 2;
      }
    }

    return ratingValue;
  }

  String toString() {
    return 'Weather: $weather, Humidity: $humidity, Rain: $rain';
  }
}
