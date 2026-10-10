import 'package:flutter/material.dart';
import '../models/forecast_day.dart';
import '../services/api_service.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<List<ForecastDay>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchForecast(); // once, not in build()
  }

  void _retry() => setState(() => _future = ApiService.fetchForecast());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ForecastDay>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 8),
                Text('${snapshot.error}', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: _retry, child: const Text('Retry')),
              ],
            ),
          );
        }
        final days = snapshot.data ?? [];
        if (days.isEmpty) {
          return const Center(child: Text('No forecast available.'));
        }
        return ListView.builder(
          itemCount: days.length,
          itemBuilder: (context, i) {
            final d = days[i];
            return ListTile(
              leading: const Icon(Icons.wb_sunny_outlined),
              title: Text(d.date),
              subtitle: Text(d.description),
              trailing: Text('${d.maxC}° / ${d.minC}°C'),
            );
          },
        );
      },
    );
  }
}
