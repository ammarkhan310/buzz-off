// object to hold weather info
class WeatherInfo {
  String city;
  String country;
  int temp;
  int humidity;
  int rain;
  String weather;
  String feelsLike = ', feels like ';

  WeatherInfo(
      {this.temp,
      this.humidity,
      this.rain,
      this.weather,
      this.city = 'NULL',
      this.country = 'NULL'});
  
  factory WeatherInfo.fromMap(Map map) {
    return WeatherInfo(
        city: map['name'],
        country: map['sys']['country'],
        temp: map['main']['temp'].toInt(),
        humidity: map['main']['humidity'],
        rain: map['rain'],
        weather: map['weather'][0]['main'] +
            ', ' +
            map['weather'][0]['description'] +
            '. Feels like ' +
            map['main']['feels_like'].round().toInt().toString() +
            '\n' +
            'Today\'s high: ' +
            map['main']['temp_max'].round().toInt().toString() +
            '            ' +
            'Today\'s low: ' +
            map['main']['temp_min'].round().toInt().toString());
  }

  String toString() {
    return ("City: $city, $country. Weather conditions: $weather, $temp K?  Humidity: $humidity");
  }
}
