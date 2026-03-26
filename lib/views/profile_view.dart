// lib/views/profile_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../viewmodels/user_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../services/local_auth_service.dart';
import '../utils/app_theme.dart';
import '../views/auth/login_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _localAuth = LocalAuthService();
  bool _editing = false;
  bool _populated = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  void _tryPopulate(dynamic user) {
    if (user == null || _populated) return;
    _nameCtrl.text = user.fullName ?? '';
    _ageCtrl.text = '${user.age}';
    _weightCtrl.text = '${user.weight}';
    _cityCtrl.text = user.city ?? '';
    _populated = true;
  }

  void _resetFields(dynamic user) {
    if (user == null) return;
    _nameCtrl.text = user.fullName ?? '';
    _ageCtrl.text = '${user.age}';
    _weightCtrl.text = '${user.weight}';
    _cityCtrl.text = user.city ?? '';
  }

  Future<void> _pickImage() async {
    final XFile? picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked == null) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    _snack('Uploading photo...');

    // Pass XFile directly — works on Web AND Mobile
    final ok =
        await context.read<UserViewModel>().uploadProfilePicture(uid, picked);
    if (!mounted) return;

    if (ok) {
      _snack('Profile picture updated!');
    } else {
      final err = context.read<UserViewModel>().error;
      _snack('Upload failed: ${err ?? 'Please try again.'}');
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final userVm = context.read<UserViewModel>();
    final weatherVm = context.read<WeatherViewModel>();
    final ok = await userVm.updateProfile(
      uid: uid,
      fullName: _nameCtrl.text.trim(),
      age: int.tryParse(_ageCtrl.text) ?? userVm.user!.age,
      weight: double.tryParse(_weightCtrl.text) ?? userVm.user!.weight,
      city: _cityCtrl.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      setState(() => _editing = false);
      if (userVm.user != null) weatherVm.refreshActivities(userVm.user!);
      _snack('Profile updated! Activities refreshed.');
    }
  }

  Future<void> _toggleBiometric(bool enabled) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    if (enabled) {
      final available = await _localAuth.isBiometricAvailable();
      if (!available) {
        _snack('Biometric not available on this device.');
        return;
      }
      final result = await _localAuth.authenticate();
      if (result != true) {
        _snack('Biometric verification failed.');
        return;
      }
    }
    await context.read<UserViewModel>().toggleBiometric(uid, enabled);
  }

  Future<void> _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Sign out')),
        ],
      ),
    );
    if (confirm != true) return;
    await context.read<AuthViewModel>().signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const LoginView()), (_) => false);
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    final userVm = context.watch<UserViewModel>();
    final user = userVm.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    _tryPopulate(user);

    if (user == null) {
      return Center(
        child: CircularProgressIndicator(
          color: isDark ? AppColors.cyan : AppColors.cyanDark,
        ),
      );
    }

    final cardBg = isDark ? AppColors.slateSurfacePlus : AppColors.white;
    final cardBorder =
        isDark ? AppColors.borderCyanDark : AppColors.borderCyanLight;
    final fieldBg = isDark ? AppColors.slateSurfaceHighlight : AppColors.offWhite;
    final goldCol = isDark ? AppColors.cyan : AppColors.cyanDark;
    final textCol = isDark ? AppColors.textLight : AppColors.textDark;
    final mutedCol =
        isDark ? AppColors.textLightMuted : AppColors.textDarkMuted;
    final statBg = isDark ? AppColors.slateSurfacePlus : AppColors.lightSurf;
    final statBorder =
        isDark ? AppColors.borderCyan60 : AppColors.borderCyanLight;
    final errorCol = isDark ? const Color(0xFFFF5F5F) : AppColors.error;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // ── Avatar ─────────────────────────────────────────────────────────
        Center(
          child: Stack(children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: goldCol, width: 1.5),
                color: statBg,
              ),
              child: ClipOval(
                child: user.profilePictureUrl != null
                    ? Image.network(user.profilePictureUrl!, fit: BoxFit.cover)
                    : Center(
                        child: Text(
                          user.fullName.isNotEmpty
                              ? user.fullName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                              fontSize: 36,
                              color: goldCol,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: goldCol),
                  child: Icon(Icons.camera_alt,
                      size: 14,
                      color: isDark ? AppColors.slateBase : AppColors.white),
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 12),

        Text(user.fullName,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: textCol,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5)),
        const SizedBox(height: 3),
        Text(user.email,
            textAlign: TextAlign.center,
            style: TextStyle(color: mutedCol, fontSize: 13)),
        const SizedBox(height: 16),

        // ── Stat chips ─────────────────────────────────────────────────────
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _StatChip(
            chipLabel: 'AGE',
            chipValue: '${user.age}',
            bgColor: statBg,
            borderColor: statBorder,
            labelColor: goldCol,
            valueColor: textCol,
          ),
          const SizedBox(width: 8),
          _StatChip(
            chipLabel: 'WEIGHT',
            chipValue: '${user.weight}kg',
            bgColor: statBg,
            borderColor: statBorder,
            labelColor: goldCol,
            valueColor: textCol,
          ),
          const SizedBox(width: 8),
          _StatChip(
            chipLabel: 'CATEGORY',
            chipValue: user.weightCategory,
            bgColor: statBg,
            borderColor: statBorder,
            labelColor: goldCol,
            valueColor: textCol,
          ),
        ]),
        const SizedBox(height: 22),

        // ── Profile info header ────────────────────────────────────────────
        _SectionHeader(
          sectionTitle: 'Profile Info',
          accentColor: goldCol,
          trailing: TextButton.icon(
            onPressed: () => setState(() {
              _editing = !_editing;
              if (!_editing) _resetFields(user);
            }),
            icon: Icon(_editing ? Icons.close : Icons.edit_outlined,
                size: 14, color: goldCol),
            label: Text(_editing ? 'Cancel' : 'Edit',
                style: TextStyle(
                    color: goldCol, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 8),

        // ── READ-ONLY view ─────────────────────────────────────────────────
        if (!_editing)
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cardBorder, width: 0.8),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _ReadField(
                fieldLabel: 'Full name',
                fieldValue: user.fullName,
                labelColor: goldCol,
                valueColor: textCol,
                bgColor: fieldBg,
                borderColor: cardBorder,
              ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: _ReadField(
                    fieldLabel: 'Age',
                    fieldValue: '${user.age}',
                    labelColor: goldCol,
                    valueColor: textCol,
                    bgColor: fieldBg,
                    borderColor: cardBorder,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ReadField(
                    fieldLabel: 'Weight',
                    fieldValue: '${user.weight} kg',
                    labelColor: goldCol,
                    valueColor: textCol,
                    bgColor: fieldBg,
                    borderColor: cardBorder,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              _ReadField(
                fieldLabel: 'City',
                fieldValue: user.city?.isNotEmpty == true ? user.city! : '—',
                labelColor: goldCol,
                valueColor: textCol,
                bgColor: fieldBg,
                borderColor: cardBorder,
              ),
            ]),
          ),

        // ── EDIT form ─────────────────────────────────────────────────────
        if (_editing)
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cardBorder, width: 0.8),
            ),
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(children: [
                _EditField(
                  fieldLabel: 'Full name',
                  ctrl: _nameCtrl,
                  textColor: textCol,
                  labelColor: goldCol,
                  bgColor: fieldBg,
                  borderColor: cardBorder,
                  focusColor: goldCol,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: _EditField(
                      fieldLabel: 'Age',
                      ctrl: _ageCtrl,
                      keyboard: TextInputType.number,
                      textColor: textCol,
                      labelColor: goldCol,
                      bgColor: fieldBg,
                      borderColor: cardBorder,
                      focusColor: goldCol,
                      validator: (v) =>
                          int.tryParse(v ?? '') == null ? 'Invalid' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _EditField(
                      fieldLabel: 'Weight (kg)',
                      ctrl: _weightCtrl,
                      keyboard:
                          const TextInputType.numberWithOptions(decimal: true),
                      textColor: textCol,
                      labelColor: goldCol,
                      bgColor: fieldBg,
                      borderColor: cardBorder,
                      focusColor: goldCol,
                      validator: (v) =>
                          double.tryParse(v ?? '') == null ? 'Invalid' : null,
                    ),
                  ),
                ]),
                const SizedBox(height: 10),
                _EditField(
                  fieldLabel: 'City',
                  ctrl: _cityCtrl,
                  textColor: textCol,
                  labelColor: goldCol,
                  bgColor: fieldBg,
                  borderColor: cardBorder,
                  focusColor: goldCol,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: userVm.loading ? null : _save,
                  child: userVm.loading
                      ? SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color:
                                  isDark ? AppColors.slateBase : AppColors.white))
                      : const Text('SAVE CHANGES'),
                ),
              ]),
            ),
          ),
        const SizedBox(height: 16),

        // ── Appearance ─────────────────────────────────────────────────────
        _SectionHeader(sectionTitle: 'Appearance', accentColor: goldCol),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cardBorder, width: 0.8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: _ToggleRow(
            rowIcon: userVm.isDarkMode
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded,
            rowTitle: 'Dark mode',
            rowSubtitle:
                userVm.isDarkMode ? 'Dark theme is on' : 'Light theme is on',
            rowValue: userVm.isDarkMode,
            onRowChanged: (val) => userVm.toggleDarkMode(val),
            iconColor: goldCol,
            titleColor: textCol,
            subtitleColor: mutedCol,
          ),
        ),
        const SizedBox(height: 16),

        // ── Security ───────────────────────────────────────────────────────
        _SectionHeader(sectionTitle: 'Security', accentColor: goldCol),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cardBorder, width: 0.8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(children: [
            _ToggleRow(
              rowIcon: Icons.fingerprint_rounded,
              rowTitle: 'Biometric login',
              rowSubtitle: 'Fingerprint or Face ID on next launch',
              rowValue: user.biometricEnabled,
              onRowChanged: _toggleBiometric,
              iconColor: goldCol,
              titleColor: textCol,
              subtitleColor: mutedCol,
            ),
            if (user.biometricEnabled) ...[
              Divider(height: 1, color: cardBorder),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.borderCyanDark.withOpacity(0.15)
                      : AppColors.borderCyanLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: cardBorder, width: 0.5),
                ),
                child: Text(
                  '✓ Active. After 3 failed attempts, password is required.',
                  style: TextStyle(color: goldCol, fontSize: 11, height: 1.5),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ]),
        ),
        const SizedBox(height: 22),

        // ── Sign out ───────────────────────────────────────────────────────
        OutlinedButton.icon(
          onPressed: _signOut,
          icon: Icon(Icons.logout_rounded, color: errorCol, size: 18),
          label: Text('SIGN OUT',
              style: TextStyle(
                  color: errorCol,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1)),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: errorCol, width: 0.8),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        const SizedBox(height: 24),
      ]),
    );
  }
}

// ── Read-only field ───────────────────────────────────────────────────────────
class _ReadField extends StatelessWidget {
  final String fieldLabel;
  final String fieldValue;
  final Color labelColor;
  final Color valueColor;
  final Color bgColor;
  final Color borderColor;

  const _ReadField({
    required this.fieldLabel,
    required this.fieldValue,
    required this.labelColor,
    required this.valueColor,
    required this.bgColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        fieldLabel.toUpperCase(),
        style: TextStyle(
            color: labelColor,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2),
      ),
      const SizedBox(height: 5),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: borderColor, width: 0.8),
        ),
        child: Text(
          fieldValue,
          style: TextStyle(
              color: valueColor, fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    ]);
  }
}

// ── Edit field ────────────────────────────────────────────────────────────────
class _EditField extends StatelessWidget {
  final String fieldLabel;
  final TextEditingController ctrl;
  final TextInputType? keyboard;
  final Color textColor;
  final Color labelColor;
  final Color bgColor;
  final Color borderColor;
  final Color focusColor;
  final String? Function(String?)? validator;

  const _EditField({
    required this.fieldLabel,
    required this.ctrl,
    this.keyboard,
    required this.textColor,
    required this.labelColor,
    required this.bgColor,
    required this.borderColor,
    required this.focusColor,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      style: TextStyle(
          color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: fieldLabel,
        labelStyle: TextStyle(
            color: labelColor, fontSize: 12, fontWeight: FontWeight.w600),
        filled: true,
        fillColor: bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide(color: borderColor, width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide(color: borderColor, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide(color: focusColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: AppColors.error, width: 0.8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      validator: validator,
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String sectionTitle;
  final Color accentColor;
  final Widget? trailing;

  const _SectionHeader({
    required this.sectionTitle,
    required this.accentColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
              color: accentColor, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 8),
        Text(
          sectionTitle.toUpperCase(),
          style: TextStyle(
              color: accentColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5),
        ),
        const Spacer(),
        if (trailing != null) trailing!,
      ]);
}

// ── Stat chip ─────────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String chipLabel;
  final String chipValue;
  final Color bgColor;
  final Color borderColor;
  final Color labelColor;
  final Color valueColor;

  const _StatChip({
    required this.chipLabel,
    required this.chipValue,
    required this.bgColor,
    required this.borderColor,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 0.8),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(chipValue,
              style: TextStyle(
                  color: valueColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 1),
          Text(chipLabel,
              style: TextStyle(
                  color: labelColor,
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
        ]),
      );
}

// ── Toggle row ────────────────────────────────────────────────────────────────
class _ToggleRow extends StatelessWidget {
  final IconData rowIcon;
  final String rowTitle;
  final String rowSubtitle;
  final bool rowValue;
  final ValueChanged<bool> onRowChanged;
  final Color iconColor;
  final Color titleColor;
  final Color subtitleColor;

  const _ToggleRow({
    required this.rowIcon,
    required this.rowTitle,
    required this.rowSubtitle,
    required this.rowValue,
    required this.onRowChanged,
    required this.iconColor,
    required this.titleColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Icon(rowIcon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(rowTitle,
                  style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
              const SizedBox(height: 2),
              Text(rowSubtitle,
                  style: TextStyle(color: subtitleColor, fontSize: 11)),
            ]),
          ),
          Switch(value: rowValue, onChanged: onRowChanged),
        ]),
      );
}
