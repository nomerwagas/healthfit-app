// lib/services/local_auth_service.dart

import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class LocalAuthService {
  final LocalAuthentication _auth = LocalAuthentication();
  int _failedAttempts = 0;
  static const int maxAttempts = 3;

  Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } on PlatformException {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  // Returns true = authenticated, false = failed, null = exceeded max attempts
  Future<bool?> authenticate() async {
    if (_failedAttempts >= maxAttempts) {
      return null; // Force password fallback
    }

    try {
      final authenticated = await _auth.authenticate(
        localizedReason: 'Scan your biometric to log in automatically',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        _failedAttempts = 0;
        return true;
      } else {
        _failedAttempts++;
        if (_failedAttempts >= maxAttempts) {
          return null; // Exceeded — force password
        }
        return false;
      }
    } on PlatformException {
      _failedAttempts++;
      return false;
    }
  }

  void resetFailedAttempts() => _failedAttempts = 0;

  int get failedAttempts => _failedAttempts;
  bool get isLocked => _failedAttempts >= maxAttempts;
}
