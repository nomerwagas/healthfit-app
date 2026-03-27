// lib/viewmodels/auth_viewmodel.dart

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../services/local_auth_service.dart';
import '../services/storage_service.dart';

enum AuthState { idle, loading, success, error }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();
  final LocalAuthService _localAuth = LocalAuthService();

  AuthState _state = AuthState.idle;
  String? _errorMessage;
  UserModel? _currentUser;
  bool _biometricAvailable = false;

  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  bool get biometricAvailable => _biometricAvailable;
  bool get isLoading => _state == AuthState.loading;

  AuthViewModel() {
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    _biometricAvailable = await _localAuth.isBiometricAvailable();
    notifyListeners();
  }

  // ── Register ──────────────────────────────────────────────────────────────
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required int age,
    required double weight,
    String? city,
  }) async {
    _setState(AuthState.loading);
    try {
      _currentUser = await _repo.registerWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        age: age,
        weight: weight,
        city: city,
      );
      _setState(AuthState.success);
      return true;
    } catch (e) {
      _setError(_parseError(e));
      return false;
    }
  }

  // ── Login with Email ──────────────────────────────────────────────────────
  Future<bool> loginWithEmail(String email, String password) async {
    _setState(AuthState.loading);
    try {
      _currentUser = await _repo.loginWithEmail(email, password);
      _setState(AuthState.success);
      return true;
    } catch (e) {
      _setError(_parseError(e));
      return false;
    }
  }

  // ── Google Sign-In ────────────────────────────────────────────────────────
  Future<bool> signInWithGoogle() async {
    _setState(AuthState.loading);
    try {
      _currentUser = await _repo.signInWithGoogle();
      if (_currentUser == null) {
        _setState(AuthState.idle);
        return false;
      }
      _setState(AuthState.success);
      return true;
    } catch (e) {
      _setError(_parseError(e));
      return false;
    }
  }

  // ── Biometric Login ───────────────────────────────────────────────────────
  Future<bool?> authenticateWithBiometrics() async {
    return await _localAuth.authenticate();
  }

  bool get isBiometricLocked => _localAuth.isLocked;
  int get biometricFailedAttempts => _localAuth.failedAttempts;

  // ── Sign Out ──────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await _repo.signOut();
    _currentUser = null;
    _setState(AuthState.idle);
  }

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void _setState(AuthState s) {
    _state = s;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String msg) {
    _state = AuthState.error;
    _errorMessage = msg;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _state = AuthState.idle;
    notifyListeners();
  }

  String _parseError(dynamic e) {
    final msg = e.toString();
    if (msg.contains('email-already-in-use')) return 'Email already registered.';
    if (msg.contains('wrong-password') || msg.contains('invalid-credential')) {
      return 'Incorrect email or password.';
    }
    if (msg.contains('user-not-found')) return 'No account found with this email.';
    if (msg.contains('network-request-failed')) return 'No internet connection.';
    if (msg.contains('too-many-requests')) {
      return 'Too many attempts. Please try again later.';
    }
    if (msg.contains('popup-closed-by-user')) {
      return 'Google sign-in was canceled.';
    }
    if (msg.contains('popup-blocked')) {
      return 'Popup was blocked. Please allow popups and try again.';
    }
    if (msg.contains('unauthorized-domain')) {
      return 'This domain is not authorized in Firebase Auth settings.';
    }
    return 'Something went wrong. Please try again.';
  }
}
