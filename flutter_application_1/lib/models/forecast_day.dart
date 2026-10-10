// One day of the forecast from wttr.in
class ForecastDay {
  final String date;
  final int maxC;
  final int minC;
  final String description;

  ForecastDay({
    required this.date,
    required this.maxC,
    required this.minC,
    required this.description,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    final hourly = json['hourly'] as List<dynamic>;
    // Pick the midday entry (index 4 = 12:00) when it exists
    final mid = (hourly.length > 4 ? hourly[4] : hourly.first)
        as Map<String, dynamic>;
    return ForecastDay(
      date: json['date'] as String,
      // wttr.in sends numbers as Strings, so parse them
      maxC: int.parse(json['maxtempC'] as String),
      minC: int.parse(json['mintempC'] as String),
      description: (mid['weatherDesc'] as List)[0]['value'] as String,
    );
  }
}
