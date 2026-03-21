// lib/utils/env_config.dart
// Keys are injected at build time via --dart-define
// Never hardcode real API keys here

class EnvConfig {
  // OpenWeatherMap API Key
  // Usage: flutter run --dart-define=WEATHER_API_KEY=your_key_here
  static const String weatherApiKey =
      String.fromEnvironment('WEATHER_API_KEY', defaultValue: '');

  // Firebase Web Config (injected during Docker build for Flutter Web)
  static const String firebaseApiKey =
      String.fromEnvironment('FIREBASE_API_KEY', defaultValue: '');
  static const String firebaseAuthDomain =
      String.fromEnvironment('FIREBASE_AUTH_DOMAIN', defaultValue: '');
  static const String firebaseProjectId =
      String.fromEnvironment('FIREBASE_PROJECT_ID', defaultValue: '');
  static const String firebaseStorageBucket =
      String.fromEnvironment('FIREBASE_STORAGE_BUCKET', defaultValue: '');
  static const String firebaseMessagingSenderId =
      String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID', defaultValue: '');
  static const String firebaseAppId =
      String.fromEnvironment('FIREBASE_APP_ID', defaultValue: '');

  static const String weatherBaseUrl =
      'https://api.openweathermap.org/data/2.5';
}
