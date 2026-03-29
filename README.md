# SkyFit Pro: Secure Identity & Health System

A secure Health & Fitness Flutter application that integrates real-time weather data with personalized activity suggestions, protected by biometric authentication and a strict MVVM architecture. This project fulfills the requirements for Laboratory T7/T8.

## 🚀 Key Features

### 🔐 Secure Identity & Auth
- **Custom Registration:** Collects Email, Password (Strong Regex), Name, Age, Weight, and City.
- **Google SSO:** Integrated "Sign in with Google" via Firebase Authentication.
- **Auth Guard:** Persistent session management that keeps users logged in or redirects to Login.

### 🛡️ Biometric Security (M2)
- **Biometric Switch:** Toggle "Enable Biometric Login" in Profile settings.
- **Auto-Login:** Prompts for Fingerprint/FaceID automatically on app launch if enabled.
- **Biometric Only:** Enforces biometric-only authentication (no PIN fallback).
- **Security Fallback:** Automatically locks biometrics and forces password entry after 3 failed attempts.
- **Secure Storage:** Sensitive tokens and credentials are encrypted at rest using `flutter_secure_storage`.

### ⏳ Session Management (M2)
- **Inactivity Timer:** Automatically monitors user interaction (taps/scrolls) via `SessionAwareWrapper`.
- **Warning Dialog:** A visual warning appears at 4 minutes 30 seconds of inactivity with a 30-second countdown.
- **Auto Logout:** Forcefully logs out and redirects to the Login screen after 5 total minutes of inactivity.

### 🌦️ Personalized Health Logic (M3 & M5)
- **Weather Integration:** Fetches real-time conditions (Temp, Humidity, Condition) from OpenWeatherMap.
- **Activity Matrix:** Suggests 3 specific activities based on:
  - **Weather:** Clear/Cloudy vs. Rain/Snow vs. Extreme Heat.
  - **Age Group:** Young (< 50) vs. Senior (>= 50).
  - **Weight Category:** Normal, Overweight, Obese, or Underweight.
- **Multimedia:** Integrated video exercise samples for each suggested activity.

### 🎨 Modern UI/UX
- **Dynamic Greeting:** Personalised "Good Morning/Evening" greeting with the user's first name.
- **Theme Support:** Full Dark Mode and Light Mode support.
- **Profile Management:** Update profile details and upload profile pictures via Cloudinary.

## 🏗️ Project Architecture (Strict MVVM)

```text
lib/
├── models/         # Data Layer (User, Weather, Activity models)
├── views/          # UI Layer (Auth, Home, Profile, Widgets)
├── viewmodels/     # Logic Layer (Auth, User, Weather viewmodels)
├── repositories/   # Data Decision Layer (Auth, Weather repositories)
├── services/       # External Services (Firebase, local_auth, storage)
└── utils/          # Helpers (App Theme, Env Config, Session Manager)
```

## 🛠️ Setup & Local Execution

### 1. Requirements
- Flutter SDK (Latest Stable)
- Firebase Project (Auth & Firestore enabled)
- OpenWeatherMap API Key

### 2. Environment Variables
This project uses `--dart-define` to inject keys at build time. **Never hardcode keys in the source.**

Required keys:
- `WEATHER_API_KEY`
- `FIREBASE_API_KEY`
- `FIREBASE_AUTH_DOMAIN`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_STORAGE_BUCKET`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_APP_ID`
- `GOOGLE_CLIENT_ID`

### 3. Running Locally
```bash
flutter run --dart-define=WEATHER_API_KEY=your_key_here
```

## ☁️ Deployment (GCP & Docker)

The project includes a multi-stage `Dockerfile` and `cloudbuild.yaml` for deployment to **GCP Cloud Run**.

1. **Stage 1 (Build):** Compiles Flutter Web with injected secrets.
2. **Stage 2 (Serve):** Uses Nginx to serve the static release files securely.

## 👥 Team Roles (Group 5)
- **M1 (Lead):** MVVM Structure, Routing, Auth State Management.
- **M2 (Security):** Biometrics, Secure Storage, Session Manager.
- **M3 (Logic):** Registration, Personalized Activity Logic, Firestore.
- **M4 (DevOps):** Docker, GCP Cloud Run, CI/CD, Secret Injection.
- **M5 (UI/UX):** Screen Implementation, Weather UI, Media Integration.
