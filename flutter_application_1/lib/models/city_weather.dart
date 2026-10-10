// Current weather for one city from wttr.in
class CityWeather {
  final String city;
  final int tempC;
  final int feelsLikeC;
  final int humidity;
  final int windKmh;
  final String description;

  CityWeather({
    required this.city,
    required this.tempC,
    required this.feelsLikeC,
    required this.humidity,
    required this.windKmh,
    required this.description,
  });

  factory CityWeather.fromJson(Map<String, dynamic> json, String city) {
    final cur = (json['current_condition'] as List)[0] as Map<String, dynamic>;
    return CityWeather(
      city: city,
      tempC: int.parse(cur['temp_C'] as String),
      feelsLikeC: int.parse(cur['FeelsLikeC'] as String),
      humidity: int.parse(cur['humidity'] as String),
      windKmh: int.parse(cur['windspeedKmph'] as String),
      description: (cur['weatherDesc'] as List)[0]['value'] as String,
    );
  }
}
