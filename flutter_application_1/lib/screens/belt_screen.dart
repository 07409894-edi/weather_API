import 'package:flutter/material.dart';
import '../models/city_weather.dart';
import '../services/api_service.dart';

class BeltScreen extends StatefulWidget {
  const BeltScreen({super.key});
  @override
  State<BeltScreen> createState() => _BeltScreenState();
}

class _BeltScreenState extends State<BeltScreen> {
  late final Stream<CityWeather> _stream;

  @override
  void initState() {
    super.initState();
    _stream = ApiService.weatherStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CityWeather>(
      stream: _stream,
      builder: (context, snapshot) {
        final w = snapshot.data;

        if (snapshot.hasError && w == null) {
          return Center(
            child: Text('${snapshot.error}\nTrying again in 5 seconds...',
                textAlign: TextAlign.center),
          );
        }
        if (w == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (snapshot.hasError)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Colors.orange.shade100,
                  child: Text('${snapshot.error} (showing last known data)'),
                ),
              const SizedBox(height: 40),
              Text(w.city,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),
              Text('${w.tempC}°C',
                  style: const TextStyle(fontSize: 56)),
              Text(w.description, style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 16),
              Text('Feels like ${w.feelsLikeC}°C'),
              Text('Humidity ${w.humidity}%'),
              Text('Wind ${w.windKmh} km/h'),
            ],
          ),
        );
      },
    );
  }
}
