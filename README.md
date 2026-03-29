# SkyFit Pro: Secure Identity & Health System

**SkyFit Pro** is a robust, secure Health & Fitness Flutter application designed for Laboratory T7/T8. It integrates real-time weather data with personalized activity suggestions, protected by biometric authentication, a 5-minute inactivity security guard, and a strict MVVM architecture. The application is containerized with Docker and deployed to GCP Cloud Run using a secure CI/CD pipeline.

---

## Team Members & Responsibilities (Group 5)

| Member | Role | Responsibilities |
| :--- | :--- | :--- |
| **Reyan Ryn Olivar** | Lead Architect & Auth Core | Setup MVVM & Routing; Implement Google Sign-In via Firebase Auth; Manage global AuthViewModel state. |
| **Aiene Berfel Sym Gascom** | Security & Biometrics | Implement `local_auth` for Biometrics; Use `flutter_secure_storage` for tokens; Ensure encryption at rest. |
| **Nomer Wagas** | Profile & Logic | Custom Registration (Age, Weight, etc.); Personalized Health Logic Engine; Firestore Database management. |
| **Arlene Rollorata** | DevOps & Cloud (GCP) | Multi-stage Dockerfile; GCP Cloud Run deployment; CI/CD via Cloud Build; Secret injection via `--dart-define`. |
| **Aime Joyce Sarita** | UI/UX & Integration | Build Login, Register, and Profile Views; Smooth UX transitions; Weather & Activity UI implementation. |

---

## Tools & Technologies

- **Frontend:** Flutter (Web/Mobile)
- **Architecture:** Strict MVVM (Model-View-ViewModel) with Repository Pattern
- **Backend/Auth:** Firebase Auth (Email/Password & Google SSO), Cloud Firestore
- **Security:** `local_auth` (Biometrics), `flutter_secure_storage` (AES Encryption)
- **External API:** OpenWeatherMap API
- **Multimedia:** Video Player (with AI-generated exercise samples)
- **DevOps:** Docker, Nginx, GCP Cloud Run, Google Cloud Build

---

## Setup & Local Execution

This project uses `--dart-define` to inject sensitive API keys and Firebase configurations at build time. **Never hardcode keys in the source code.**

### 1. Prerequisites
- Flutter SDK (Latest Stable)
- A Firebase Project with Auth and Firestore enabled.
- An OpenWeatherMap API Key.

### 2. Required Environment Variables
You must provide the following keys during execution:
- `WEATHER_API_KEY`: Your OpenWeatherMap API Key.
- `FIREBASE_API_KEY` to `GOOGLE_CLIENT_ID`: These come from your Firebase project's Web App configuration.

#### How to obtain these credentials:

**A. OpenWeatherMap (Weather API Key)**
1. Sign up at [OpenWeatherMap](https://openweathermap.org/api).
2. Go to your **API Keys** tab in the dashboard.
3. Generate/Copy your **AppID (API Key)**.

**B. Firebase Web Configuration**
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Select your project (or create a new one).
3. Enable **Authentication** (Email/Password & Google) and **Firestore**.
4. Go to **Project Settings** (gear icon) > **General**.
5. Scroll down to **"Your apps"** and select your **Web App** (create one if you haven't).
6. Look for the `firebaseConfig` object. It contains:
   - `apiKey` → `FIREBASE_API_KEY`
   - `authDomain` → `FIREBASE_AUTH_DOMAIN`
   - `projectId` → `FIREBASE_PROJECT_ID`
   - `storageBucket` → `FIREBASE_STORAGE_BUCKET`
   - `messagingSenderId` → `FIREBASE_MESSAGING_SENDER_ID`
   - `appId` → `FIREBASE_APP_ID`

**C. Google Client ID (for SSO)**
1. In the Firebase Console, go to **Authentication** > **Providers** > **Google**.
2. Under "Web SDK configuration", you will find the **Web client ID**.

### 3. Running Locally
Run the following command in your terminal (replace placeholders with your actual keys):

```bash
flutter run \
  --dart-define=WEATHER_API_KEY=your_weather_key \
  --dart-define=FIREBASE_API_KEY=your_firebase_key \
  --dart-define=FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com \
  --dart-define=FIREBASE_PROJECT_ID=your_project_id \
  --dart-define=FIREBASE_STORAGE_BUCKET=your_project.appspot.com \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=your_sender_id \
  --dart-define=FIREBASE_APP_ID=your_app_id \
  --dart-define=GOOGLE_CLIENT_ID=your_google_client_id
```

---

## Project Structure (Strict MVVM)

```text
lib/
├── models/         # Data Layer (User, Weather, Activity)
├── views/          # UI Layer (Auth, Home, Profile, Widgets)
├── viewmodels/     # Logic Layer (Auth, User, Weather)
├── repositories/   # Data Decision Layer (Auth, Weather)
├── services/       # External Services (Firebase, local_auth, storage)
└── utils/          # Helpers (App Theme, Env Config, Session Manager)
```

---

## Deployment (GCP & Docker)

The project includes a multi-stage `Dockerfile` and `cloudbuild.yaml` for deployment.
1. **Build Stage:** Compiles Flutter Web with injected secrets.
2. **Serve Stage:** Uses Nginx to serve the static release files securely.
3. **CI/CD:** Automated via Google Cloud Build to Cloud Run.
