// lib/models/weather_model.dart

class WeatherModel {
  final double temperature;
  final double humidity;
  final String condition;     // e.g. "Clear", "Rain", "Snow", "Extreme"
  final String description;   // e.g. "clear sky"
  final String iconCode;
  final String cityName;

  WeatherModel({
    required this.temperature,
    required this.humidity,
    required this.condition,
    required this.description,
    required this.iconCode,
    required this.cityName,
  });

  // Normalizes weather condition for activity logic
  String get normalizedCondition {
    final c = condition.toLowerCase();
    if (c.contains('clear') || c.contains('sun')) return 'clear';
    if (c.contains('rain') || c.contains('drizzle')) return 'rain';
    if (c.contains('snow')) return 'snow';
    if (c.contains('thunder') || c.contains('storm')) return 'rain';
    if (temperature >= 38) return 'extreme_heat';
    if (c.contains('cloud')) return 'cloud';
    return 'clear';
  }

  String get iconUrl =>
      'https://openweathermap.org/img/wn/$iconCode@2x.png';

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    final main = json['main'];
    return WeatherModel(
      temperature: (main['temp'] as num).toDouble(),
      humidity: (main['humidity'] as num).toDouble(),
      condition: weather['main'] ?? 'Clear',
      description: weather['description'] ?? '',
      iconCode: weather['icon'] ?? '01d',
      cityName: json['name'] ?? '',
    );
  }
}
