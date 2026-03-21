// lib/views/auth/register_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../repositories/auth_repository.dart';
import '../../utils/app_theme.dart';
import '../home_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _emailCtrl,
      _passCtrl,
      _confirmCtrl,
      _ageCtrl,
      _weightCtrl,
      _cityCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final vm = context.read<AuthViewModel>();
    final ok = await vm.register(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      fullName: _nameCtrl.text.trim(),
      age: int.parse(_ageCtrl.text.trim()),
      weight: double.parse(_weightCtrl.text.trim()),
      city: _cityCtrl.text.trim().isEmpty ? null : _cityCtrl.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => const HomeView()), (_) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(vm.errorMessage ?? 'Registration failed.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Adaptive colors
    final goldCol = isDark ? AppColors.gold : AppColors.goldDark;
    final textCol = isDark ? AppColors.textLight : AppColors.textDark;
    final mutedCol =
        isDark ? AppColors.textLightMuted : AppColors.textDarkMuted;
    final hintCol = isDark ? AppColors.textLightHint : AppColors.textDarkHint;
    final borderCol =
        isDark ? AppColors.borderGoldDark : AppColors.borderGoldLight;
    final headerBg = isDark ? AppColors.white07 : AppColors.lightSurf;
    final passHintBg = isDark
        ? AppColors.borderGoldDark.withOpacity(0.15)
        : AppColors.borderGoldLight.withOpacity(0.3);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios_new_rounded, color: goldCol, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('CREATE ACCOUNT'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header banner ────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: headerBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderCol, width: 0.8),
                ),
                child: Row(children: [
                  Icon(Icons.person_outline_rounded, color: goldCol, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your Health Profile',
                            style: TextStyle(
                                color: textCol,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                        const SizedBox(height: 2),
                        Text('We personalize activities based on your data',
                            style: TextStyle(color: mutedCol, fontSize: 10)),
                      ],
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 20),

              _field(context, 'Full name', _nameCtrl,
                  hint: 'Juan dela Cruz',
                  icon: Icons.badge_outlined,
                  goldCol: goldCol,
                  textCol: textCol,
                  hintCol: hintCol,
                  validator: (v) => v!.trim().isEmpty ? 'Required' : null),
              const SizedBox(height: 14),

              _field(context, 'Email address', _emailCtrl,
                  hint: 'juan@email.com',
                  icon: Icons.email_outlined,
                  keyboard: TextInputType.emailAddress,
                  goldCol: goldCol,
                  textCol: textCol,
                  hintCol: hintCol,
                  validator: (v) => AuthRepository.validateEmail(v ?? '')),
              const SizedBox(height: 14),

              Row(children: [
                Expanded(
                  child: _field(context, 'Age', _ageCtrl,
                      hint: '22',
                      icon: Icons.cake_outlined,
                      keyboard: TextInputType.number,
                      goldCol: goldCol,
                      textCol: textCol,
                      hintCol: hintCol, validator: (v) {
                    final n = int.tryParse(v ?? '');
                    return (n == null || n < 1 || n > 120) ? 'Invalid' : null;
                  }),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _field(context, 'Weight (kg)', _weightCtrl,
                      hint: '68',
                      icon: Icons.monitor_weight_outlined,
                      keyboard:
                          const TextInputType.numberWithOptions(decimal: true),
                      goldCol: goldCol,
                      textCol: textCol,
                      hintCol: hintCol, validator: (v) {
                    final n = double.tryParse(v ?? '');
                    return (n == null || n < 1) ? 'Invalid' : null;
                  }),
                ),
              ]),
              const SizedBox(height: 14),

              _field(context, 'City (for weather)', _cityCtrl,
                  hint: 'e.g. Manila',
                  icon: Icons.location_city_outlined,
                  goldCol: goldCol,
                  textCol: textCol,
                  hintCol: hintCol),
              const SizedBox(height: 14),

              _field(context, 'Password', _passCtrl,
                  hint: '••••••••',
                  icon: Icons.lock_outlined,
                  obscure: _obscure,
                  goldCol: goldCol,
                  textCol: textCol,
                  hintCol: hintCol,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: hintCol,
                      size: 18,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  validator: (v) => AuthRepository.validatePassword(v ?? '')),
              const SizedBox(height: 8),

              // ── Password requirements hint ────────────────────────────────
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: passHintBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderCol, width: 0.8),
                ),
                child: Text(
                  '✓ Min 8 chars  ✓ Uppercase  ✓ Lowercase  '
                  '✓ Number  ✓ Special char (!@#\$...)',
                  style: TextStyle(color: goldCol, fontSize: 10, height: 1.5),
                ),
              ),
              const SizedBox(height: 14),

              _field(context, 'Confirm password', _confirmCtrl,
                  hint: '••••••••',
                  icon: Icons.lock_outlined,
                  obscure: _obscure,
                  goldCol: goldCol,
                  textCol: textCol,
                  hintCol: hintCol,
                  validator: (v) =>
                      v != _passCtrl.text ? 'Passwords do not match' : null),
              const SizedBox(height: 28),

              FilledButton(
                onPressed: vm.isLoading ? null : _register,
                child: vm.isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isDark ? AppColors.black : AppColors.white))
                    : const Text('CREATE ACCOUNT'),
              ),
              const SizedBox(height: 16),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Already have an account? ',
                    style: TextStyle(color: mutedCol, fontSize: 13)),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Sign in'),
                ),
              ]),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    BuildContext context,
    String fieldLabel,
    TextEditingController ctrl, {
    String? hint,
    IconData? icon,
    TextInputType? keyboard,
    bool obscure = false,
    Widget? suffixIcon,
    required Color goldCol,
    required Color textCol,
    required Color hintCol,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderCol =
        isDark ? AppColors.borderGoldDark : AppColors.borderGoldLight;
    final bgCol = isDark ? AppColors.black3 : AppColors.offWhite;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        fieldLabel.toUpperCase(),
        style: TextStyle(
            color: goldCol,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2),
      ),
      const SizedBox(height: 6),
      TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        obscureText: obscure,
        style: TextStyle(
            color: textCol, fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: hintCol),
          filled: true,
          fillColor: bgCol,
          prefixIcon:
              icon != null ? Icon(icon, color: goldCol, size: 20) : null,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderCol, width: 0.8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: borderCol, width: 0.8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: goldCol, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: isDark ? const Color(0xFFFF5F5F) : AppColors.error,
                width: 0.8),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        validator: validator,
      ),
    ]);
  }
}
