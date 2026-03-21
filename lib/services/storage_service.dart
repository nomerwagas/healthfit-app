// lib/services/storage_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyBiometricEnabled = 'biometric_enabled';
  static const _keyUserEmail = 'user_email';

  // ── Secure Storage (sensitive data) ──────────────────────────────────────
  static Future<void> saveBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: _keyBiometricEnabled,
      value: enabled.toString(),
    );
  }

  static Future<bool> getBiometricEnabled() async {
    final value = await _storage.read(key: _keyBiometricEnabled);
    return value == 'true';
  }

  static Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _keyUserEmail, value: email);
  }

  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // ── SharedPreferences (non-sensitive data) ────────────────────────────────
  static Future<void> saveCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('city', city);
  }

  static Future<String?> getCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('city');
  }

  static Future<void> saveLastLogin(DateTime dateTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_login', dateTime.toIso8601String());
  }

  static Future<DateTime?> getLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('last_login');
    return value != null ? DateTime.tryParse(value) : null;
  }

  static Future<void> saveDarkMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', enabled);
  }

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dark_mode') ?? false;
  }
}
