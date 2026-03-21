// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../utils/env_config.dart';

class ApiService {
  static Future<WeatherModel> fetchWeather(String city) async {
    final apiKey = EnvConfig.weatherApiKey;

    if (apiKey.isEmpty) {
      throw Exception(
        'OpenWeatherMap API key not found. '
        'Run with: flutter run --dart-define=WEATHER_API_KEY=your_key',
      );
    }

    final url = Uri.parse(
      '${EnvConfig.weatherBaseUrl}/weather'
      '?q=${Uri.encodeComponent(city)}'
      '&appid=$apiKey'
      '&units=metric',
    );

    final response = await http.get(url).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('City "$city" not found. Please check the spelling.');
    } else if (response.statusCode == 401) {
      throw Exception('Invalid API key. Check your OpenWeatherMap key.');
    } else {
      throw Exception('Failed to fetch weather. Status: ${response.statusCode}');
    }
  }

  static Future<WeatherModel> fetchWeatherByCoords(
    double lat,
    double lon,
  ) async {
    final apiKey = EnvConfig.weatherApiKey;
    final url = Uri.parse(
      '${EnvConfig.weatherBaseUrl}/weather'
      '?lat=$lat&lon=$lon'
      '&appid=$apiKey'
      '&units=metric',
    );

    final response = await http.get(url).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch weather by location.');
    }
  }
}
