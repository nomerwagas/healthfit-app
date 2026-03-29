# healthapp2

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

### Firebase Web configuration

This app uses Firebase Web config from build-time env vars. Do not hardcode your Firebase credentials into source files.

The required env keys are:

- `WEATHER_API_KEY`
- `FIREBASE_API_KEY`
- `FIREBASE_AUTH_DOMAIN`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_STORAGE_BUCKET`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_APP_ID`
- `FIREBASE_MEASUREMENT_ID` (optional)
- `GOOGLE_CLIENT_ID`

### Example local run

```bash
flutter run -d chrome \
  --dart-define=WEATHER_API_KEY=YOUR_WEATHER_KEY \
  --dart-define=FIREBASE_API_KEY=YOUR_FIREBASE_API_KEY \
  --dart-define=FIREBASE_AUTH_DOMAIN=YOUR_FIREBASE_AUTH_DOMAIN \
  --dart-define=FIREBASE_PROJECT_ID=YOUR_FIREBASE_PROJECT_ID \
  --dart-define=FIREBASE_STORAGE_BUCKET=YOUR_FIREBASE_STORAGE_BUCKET \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=YOUR_FIREBASE_MESSAGING_SENDER_ID \
  --dart-define=FIREBASE_APP_ID=YOUR_FIREBASE_APP_ID \
  --dart-define=FIREBASE_MEASUREMENT_ID=YOUR_FIREBASE_MEASUREMENT_ID \
  --dart-define=GOOGLE_CLIENT_ID=YOUR_GOOGLE_CLIENT_ID
```

### Cloud Build / Secret Manager

Your `cloudbuild.yaml` should fetch secrets for these names:

- `WEATHER_API_KEY`
- `FIREBASE_API_KEY`
- `FIREBASE_AUTH_DOMAIN`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_STORAGE_BUCKET`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_APP_ID`
- `FIREBASE_MEASUREMENT_ID`
- `GOOGLE_CLIENT_ID`

Do not store secret values directly in the repository.

## More resources

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)
