class WeatherInfo {
  String city;
  String country;
  int temp;
  int humidity;
  String weather;

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
      weather: map['weather'][0]['main'],
    );
  }

  String toString() {
    return ("City: $city, $country. Weather conditions: $weather, $temp K?  Humidity: $humidity");
  }
}
