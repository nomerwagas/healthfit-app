// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/user_viewmodel.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'views/auth/login_view.dart';
import 'views/home_view.dart';
import 'utils/app_theme.dart';
import 'firebase_options.dart';
import 'repositories/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for black theme
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.slateBase,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const HealthApp());
}

class HealthApp extends StatelessWidget {
  const HealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(
            create: (_) => UserViewModel()..loadThemePreference()),
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
      ],
      child: Consumer<UserViewModel>(
        builder: (context, userVm, _) {
          return MaterialApp(
            title: 'HealthFit',
            debugShowCheckedModeBanner: false,
            themeMode: userVm.themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: const AuthGuard(),
          );
        },
      ),
    );
  }
}

class AuthGuard extends StatefulWidget {
  const AuthGuard({super.key});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  final _repo = AuthRepository();
  bool _redirectChecked = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Must await getRedirectResult() before reading authStateChanges()
    // so Firebase can complete the web redirect sign-in.
    await _repo.completeWebRedirect();
    if (mounted) setState(() => _redirectChecked = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_redirectChecked) {
      // Wait until redirect is processed before checking auth state
      return const Scaffold(
        backgroundColor: AppColors.slateBase,
        body: Center(child: CircularProgressIndicator(color: AppColors.cyan)),
      );
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.slateBase,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.cyan),
            ),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeView();
        }
        return const LoginView();
      },
    );
  }
}
