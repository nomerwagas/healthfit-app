// lib/services/storage_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyBiometricEnabled = 'biometric_enabled';
  static const _keyBiometricEmail = 'biometric_email';
  static const _keyBiometricPassword = 'biometric_password';
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

  static Future<void> saveBiometricEmail(String email) async {
    await _storage.write(key: _keyBiometricEmail, value: email);
  }

  static Future<String?> getBiometricEmail() async {
    return await _storage.read(key: _keyBiometricEmail);
  }

  static Future<void> saveBiometricPassword(String password) async {
    await _storage.write(key: _keyBiometricPassword, value: password);
  }

  static Future<String?> getBiometricPassword() async {
    return await _storage.read(key: _keyBiometricPassword);
  }

  static Future<void> saveBiometricCredentials(
      String email, String password) async {
    await _storage.write(key: _keyBiometricEmail, value: email);
    await _storage.write(key: _keyBiometricPassword, value: password);
  }

  static Future<Map<String, String>?> getBiometricCredentials() async {
    var email = await getBiometricEmail();
    if (email == null || email.isEmpty) {
      email = await getUserEmail();
    }
    final password = await getBiometricPassword();
    if (email == null || email.isEmpty || password == null || password.isEmpty) {
      return null;
    }
    return {'email': email, 'password': password};
  }

  static Future<void> clearBiometricPreferences() async {
    await _storage.delete(key: _keyBiometricEnabled);
    await _storage.delete(key: _keyBiometricEmail);
    await _storage.delete(key: _keyBiometricPassword);
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
