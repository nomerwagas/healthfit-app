// lib/views/auth/login_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../repositories/auth_repository.dart';
import '../../services/storage_service.dart';
import '../../utils/app_theme.dart';
import '../widgets/app_logo.dart';
import 'register_view.dart';
import '../home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _checking = true;
  bool _biometricEnabled = false;
  bool _biometricConfigured = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkBiometric() async {
    final enabled = await StorageService.getBiometricEnabled();
    final credentials = await StorageService.getBiometricCredentials();
    setState(() {
      _checking = false;
      _biometricEnabled = enabled && credentials != null;
    });
  }

  Future<void> _attemptBiometric() async {
    final vm = context.read<AuthViewModel>();
    if (vm.isBiometricLocked) {
      _snack('Too many attempts. Please use your password.');
      return;
    }

    final result = await vm.authenticateWithBiometrics();
    if (!mounted) return;
    if (result == true) {
      final creds = await StorageService.getBiometricCredentials();
      if (creds == null) {
        _snack('Biometric verified, but saved credentials are missing. Please sign in with your email and password.');
        return;
      }

      final savedEmail = creds['email']!.trim();
      final savedPassword = creds['password']!;
      _snack('Biometric verified. Signing you in...');
      final ok = await vm.loginWithEmail(savedEmail, savedPassword);
      if (!mounted) return;
      if (ok) {
        _goHome();
        return;
      }
      _snack(vm.errorMessage ?? 'Biometric login failed. Please sign in with your password.');
    } else if (result == null) {
      _snack('Biometric locked. Please enter your password.');
    } else {
      _snack('Biometric failed (${vm.biometricFailedAttempts}/3). Try again.');
    }
  }

  void _goHome() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => const HomeView()));

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final vm = context.read<AuthViewModel>();
    final ok = await vm.loginWithEmail(_emailCtrl.text.trim(), _passCtrl.text);
    if (!mounted) return;
    if (ok) {
      _goHome();
    } else {
      _snack(vm.errorMessage ?? 'Login failed.');
    }
  }

  Future<void> _googleSignIn() async {
    final vm = context.read<AuthViewModel>();
    final ok = await vm.signInWithGoogle();
    if (!mounted) return;
    if (ok) {
      _goHome();
    } else if (vm.errorMessage != null) {
      _snack(vm.errorMessage!);
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.cyan : AppColors.cyanDark;
    final textColor = isDark ? AppColors.textLight : AppColors.textDark;
    final mutedColor =
        isDark ? AppColors.textLightMuted : AppColors.textDarkMuted;

    return Scaffold(
      body: _checking
          ? Center(child: CircularProgressIndicator(color: goldColor))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 48),

                      // ── Logo ─────────────────────────────────────────────
                      const Center(
                        child: AppLogo(size: 90, showName: true, showTag: true),
                      ),
                      const SizedBox(height: 48),

                      // ── Email ─────────────────────────────────────────────
                      _GoldLabel('Email address', color: goldColor),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'you@email.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (v) => AuthRepository.validateEmail(v ?? ''),
                      ),
                      const SizedBox(height: 16),

                      // ── Password ──────────────────────────────────────────
                      _GoldLabel('Password', color: goldColor),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscure,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter password' : null,
                      ),
                      const SizedBox(height: 28),

                      // ── Sign in button ────────────────────────────────────
                      FilledButton(
                        onPressed: vm.isLoading ? null : _login,
                        child: vm.isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: isDark
                                        ? AppColors.slateBase
                                        : AppColors.white))
                            : const Text('SIGN IN'),
                      ),
                      const SizedBox(height: 12),

                      // ── Biometric ─────────────────────────────────────────
                      if (vm.biometricAvailable && _biometricEnabled)
                        OutlinedButton.icon(
                          onPressed: vm.isLoading ? null : _attemptBiometric,
                          icon: const Icon(Icons.fingerprint_rounded, size: 20),
                          label: const Text('Sign in with Biometrics'),
                        ),

                      const SizedBox(height: 20),

                      // ── Divider ───────────────────────────────────────────
                      Row(children: [
                        Expanded(
                            child: Divider(
                                color: isDark
                                    ? AppColors.borderCyanDark
                                    : AppColors.borderCyanLight)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text('OR',
                              style: TextStyle(
                                  color: mutedColor,
                                  fontSize: 11,
                                  letterSpacing: 1)),
                        ),
                        Expanded(
                            child: Divider(
                                color: isDark
                                    ? AppColors.borderCyanDark
                                    : AppColors.borderCyanLight)),
                      ]),
                      const SizedBox(height: 20),

                      // ── Google ────────────────────────────────────────────
                      OutlinedButton.icon(
                        onPressed: vm.isLoading ? null : _googleSignIn,
                        icon: const Icon(Icons.g_mobiledata_rounded, size: 22),
                        label: const Text('Continue with Google'),
                      ),
                      const SizedBox(height: 28),

                      // ── Register link ─────────────────────────────────────
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('New to HealthFit? ',
                                style:
                                    TextStyle(color: mutedColor, fontSize: 13)),
                            TextButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const RegisterView())),
                              child: const Text('Create account'),
                            ),
                          ]),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _GoldLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _GoldLabel(this.text, {required this.color});
  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      );
}
