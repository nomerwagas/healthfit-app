// lib/repositories/weather_repository.dart

import '../models/weather_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class WeatherRepository {
  WeatherModel? _cachedWeather;
  DateTime? _lastFetched;
  static const _cacheDuration = Duration(minutes: 30);

  bool get _isCacheValid =>
      _cachedWeather != null &&
      _lastFetched != null &&
      DateTime.now().difference(_lastFetched!) < _cacheDuration;

  Future<WeatherModel> getWeather(String city) async {
    // Return cache if still valid
    if (_isCacheValid && _cachedWeather!.cityName.toLowerCase() == city.toLowerCase()) {
      return _cachedWeather!;
    }

    // Fetch from API
    final weather = await ApiService.fetchWeather(city);
    _cachedWeather = weather;
    _lastFetched = DateTime.now();

    // Save city preference
    await StorageService.saveCity(city);

    return weather;
  }

  void invalidateCache() {
    _cachedWeather = null;
    _lastFetched = null;
  }
}
