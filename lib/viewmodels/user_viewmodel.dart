// lib/viewmodels/user_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../services/cloudinary_service.dart';

class UserViewModel extends ChangeNotifier {
  UserModel? _user;
  bool _loading = false;
  String? _error;
  ThemeMode _themeMode = ThemeMode.system;

  UserModel? get user => _user;
  bool get loading => _loading;
  String? get error => _error;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  // ── Load theme preference ─────────────────────────────────────────────────
  Future<void> loadThemePreference() async {
    final isDark = await StorageService.getDarkMode();
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // ── Toggle dark mode ──────────────────────────────────────────────────────
  Future<void> toggleDarkMode(bool enabled) async {
    _themeMode = enabled ? ThemeMode.dark : ThemeMode.light;
    await StorageService.saveDarkMode(enabled);
    notifyListeners();
  }

  // ── Load profile from Firestore ───────────────────────────────────────────
  Future<void> loadUser(String uid) async {
    _loading = true;
    notifyListeners();
    try {
      _user = await FirestoreService.getUser(uid);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ── Update profile ────────────────────────────────────────────────────────
  Future<bool> updateProfile({
    required String uid,
    String? fullName,
    int? age,
    double? weight,
    String? city,
  }) async {
    _loading = true;
    notifyListeners();
    try {
      final updates = <String, dynamic>{};
      if (fullName != null) updates['fullName'] = fullName;
      if (age != null) updates['age'] = age;
      if (weight != null) updates['weight'] = weight;
      if (city != null) {
        updates['city'] = city;
        await StorageService.saveCity(city);
      }

      await FirestoreService.updateUser(uid, updates);

      _user = _user?.copyWith(
        fullName: fullName,
        age: age,
        weight: weight,
        city: city,
      );

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ── Upload profile picture via Cloudinary ─────────────────────────────────
  // Uses XFile — works on Flutter Web AND Mobile
  Future<bool> uploadProfilePicture(String uid, XFile xFile) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final url =
          await CloudinaryService.uploadProfilePictureFromXFile(uid, xFile);
      await FirestoreService.updateUser(uid, {'profilePictureUrl': url});
      _user = _user?.copyWith(profilePictureUrl: url);
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ── Toggle biometric ──────────────────────────────────────────────────────
  Future<void> toggleBiometric(String uid, bool enabled) async {
    await FirestoreService.setBiometricEnabled(uid, enabled);
    await StorageService.saveBiometricEnabled(enabled);
    if (enabled && _user?.email != null) {
      final password = await StorageService.getBiometricPassword();
      if (password != null && password.isNotEmpty) {
        await StorageService.saveBiometricCredentials(_user!.email, password);
      } else {
        await StorageService.saveBiometricEmail(_user!.email);
      }
    } else {
      await StorageService.clearBiometricPreferences();
    }
    _user = _user?.copyWith(biometricEnabled: enabled);
    notifyListeners();
  }
}
