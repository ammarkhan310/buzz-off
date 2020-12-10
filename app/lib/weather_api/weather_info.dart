class WeatherInfo {
  String city;
  String country;
  int temp;
  int humidity;
  String weather;
  String feelsLike = ', feels like ';

  WeatherInfo(
      {this.temp,
      this.humidity,
      this.weather,
      this.city = 'NULL',
      this.country = 'NULL'});

  factory WeatherInfo.fromMap(Map map) {
    return WeatherInfo(
        city: map['name'],
        country: map['sys']['country'],
        temp: map['main']['temp'].toInt(),
        humidity: map['main']['humidity'],
        weather: map['weather'][0]['main'] +
            ', ' +
            map['weather'][0]['description'] +
            ', feels like ' +
            map['main']['feels_like'].round().toInt().toString() +
            '\n' +
            'Max temp: ' +
            map['main']['temp_max'].round().toInt().toString() +
            '\t    ' +
            'Min temp: ' +
            map['main']['temp_min'].round().toInt().toString());
  }

  String toString() {
    return ("City: $city, $country. Weather conditions: $weather, $temp K?  Humidity: $humidity");
  }
}
