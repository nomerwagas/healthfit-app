// lib/viewmodels/weather_viewmodel.dart

import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/activity_model.dart';
import '../models/user_model.dart';
import '../repositories/weather_repository.dart';
import '../services/storage_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository _repo = WeatherRepository();

  WeatherModel? _weather;
  List<ActivityModel> _activities = [];
  bool _loading = false;
  String? _error;
  String _city = '';

  WeatherModel? get weather => _weather;
  List<ActivityModel> get activities => _activities;
  bool get loading => _loading;
  String? get error => _error;
  String get city => _city;

  Future<void> initialize([String? uid]) async {
    final savedCity = await StorageService.getCity(uid);
    if (savedCity != null && savedCity.isNotEmpty) {
      _city = savedCity;
    }
  }

  void reset() {
    _weather = null;
    _activities = [];
    _loading = false;
    _error = null;
    _city = '';
    notifyListeners();
  }

  Future<void> fetchWeather(String city, UserModel user) async {
    if (city.trim().isEmpty) {
      _error = 'Please enter a city name.';
      notifyListeners();
      return;
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await _repo.getWeather(city.trim());
      _city = city.trim();
      _computeActivities(user);
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ── Called when user profile changes (age/weight) ─────────────────────────
  // Recomputes activity suggestions without re-fetching weather
  void refreshActivities(UserModel user) {
    if (_weather == null) return;
    _computeActivities(user);
    notifyListeners();
  }

  void _computeActivities(UserModel user) {
    if (_weather == null) return;
    _activities = ActivityModel.getSuggestions(
      weatherCondition: _weather!.normalizedCondition,
      ageGroup: user.ageGroup,
      weightCategory: user.weightCategory,
      // Seed makes suggestions vary when age/weight change (lab requirement).
      seed: (user.age * 1000) ^ (user.weight * 10).round(),
    );
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
