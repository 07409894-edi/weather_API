import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city_weather.dart';
import '../models/forecast_day.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

// Weather API: wttr.in (free, JSON, no API key). Not Open-Meteo.
class ApiService {
  static const _timeout = Duration(seconds: 15);
  static const homeCity = 'Legazpi,Philippines';
  // Screen 2 cycles through these, so the data changes every tick.
  static const beltCities = [
    'Legazpi,Philippines',
    'Manila',
    'Cebu',
    'Davao',
    'Tokyo',
    'London',
  ];

  static Future<Map<String, dynamic>> _getJson(String city) async {
    try {
      final url = Uri.parse('https://wttr.in/${Uri.encodeComponent(city)}?format=j1');
      final response = await http.get(url).timeout(_timeout);
      if (response.statusCode != 200) {
        throw ApiException('Server error (${response.statusCode})');
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on TimeoutException {
      throw ApiException('Request timed out. Check your connection.');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Cannot reach the server. Are you offline?');
    }
  }

  // ---- Screen 1: Future (3-day forecast for the home city) ----
  static Future<List<ForecastDay>> fetchForecast() async {
    final data = await _getJson(homeCity);
    final days = data['weather'] as List<dynamic>;
    return days
        .map((e) => ForecastDay.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ---- Screen 2: Stream (a different city's weather every 5 seconds) ----
  static Future<CityWeather> fetchCity(String city) async {
    final data = await _getJson(city);
    return CityWeather.fromJson(data, city.split(',').first);
  }

  static Stream<CityWeather> weatherStream() {
    late StreamController<CityWeather> controller;
    Timer? timer;
    var index = 0;

    Future<void> tick() async {
      final city = beltCities[index % beltCities.length];
      index++; // move to the next city even if this fetch fails
      try {
        final w = await fetchCity(city);
        if (!controller.isClosed) controller.add(w);
      } catch (e) {
        if (!controller.isClosed) controller.addError(e); // stream survives
      }
    }

    controller = StreamController<CityWeather>(
      onListen: () {
        tick();
        timer = Timer.periodic(const Duration(seconds: 5), (_) => tick());
      },
      onCancel: () => timer?.cancel(),
    );
    return controller.stream;
  }
}
