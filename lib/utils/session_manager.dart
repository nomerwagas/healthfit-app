// lib/utils/session_manager.dart
//
// Requirement (M2):
//   - Create a SessionManager class
//   - Use a Timer that resets on user interaction (tap/scroll)
//   - Logic: if (inactiveTime > 5 mins) → Navigator.pushReplacement(LoginScreen)
//
// Implementation:
//   • 0:00 - 4:30  → User active, timer keeps resetting on tap/scroll
//   • 4:30         → Warning dialog appears with 30s countdown
//   • 5:00         → Auto logout → Navigator.pushReplacement(LoginScreen)
//   • "Stay signed in" tapped → full 5min timer restarts

import 'dart:async';
import 'package:flutter/material.dart';
import 'app_theme.dart';

// ── SessionManager class ──────────────────────────────────────────────────────
class SessionManager {
  // Timings — total 5 minutes as per requirement
  static const Duration _inactivityLimit = Duration(minutes: 5); // 5 mins total
  static const Duration _warningBefore =
      Duration(seconds: 30); // warn 30s before
  static const Duration _warningAt =
      Duration(minutes: 4, seconds: 30); // show at 4m30s

  Timer? _inactivityTimer;
  Timer? _logoutTimer;
  Timer? _countdownTick;

  final VoidCallback onSessionExpired;
  final BuildContext Function() getContext;

  bool _dialogShowing = false;

  SessionManager({
    required this.onSessionExpired,
    required this.getContext,
  });

  // ── Called on every user interaction (tap / scroll) ───────────────────────
  void resetTimer() {
    _cancelAll();
    // Show warning at 4m30s
    _inactivityTimer = Timer(_warningAt, _showWarningDialog);
  }

  // ── Warning dialog at 4m30s ────────────────────────────────────────────────
  void _showWarningDialog() {
    if (_dialogShowing) return;
    _dialogShowing = true;

    // After 30 more seconds → force logout (total = 5 mins)
    _logoutTimer = Timer(_warningBefore, _forceLogout);

    _openDialog(getContext());
  }

  // ── Force logout after 5 mins ──────────────────────────────────────────────
  void _forceLogout() {
    _cancelAll();
    _closeDialog();
    // Navigate to login screen (pushReplacement as per requirement)
    onSessionExpired();
  }

  void _closeDialog() {
    if (!_dialogShowing) return;
    _dialogShowing = false;
    try {
      Navigator.of(getContext(), rootNavigator: true).pop();
    } catch (_) {}
  }

  void _cancelAll() {
    _inactivityTimer?.cancel();
    _logoutTimer?.cancel();
    _countdownTick?.cancel();
    _inactivityTimer = _logoutTimer = _countdownTick = null;
  }

  void dispose() => _cancelAll();

  // ── Dialog UI ──────────────────────────────────────────────────────────────
  void _openDialog(BuildContext context) {
    int countdown = 30;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          // Tick every second
          _countdownTick?.cancel();
          _countdownTick = Timer.periodic(const Duration(seconds: 1), (t) {
            if (!ctx.mounted) {
              t.cancel();
              return;
            }
            if (countdown > 0) {
              setDialogState(() => countdown--);
            } else {
              t.cancel();
            }
          });

          final isDark = Theme.of(context).brightness == Brightness.dark;
          final goldCol = isDark ? AppColors.cyan : AppColors.cyanDark;
          final textCol = isDark ? AppColors.textLight : AppColors.textDark;
          final mutedCol =
              isDark ? AppColors.textLightMuted : AppColors.textDarkMuted;
          final cardBg = isDark ? AppColors.slateSurfacePlus : AppColors.white;
          final borderCol =
              isDark ? AppColors.borderCyanDark : AppColors.borderCyanLight;
          final iconBg = isDark
              ? AppColors.borderCyanDark.withOpacity(0.2)
              : AppColors.borderCyanLight.withOpacity(0.4);
          final progress = countdown / 30.0;

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: goldCol, width: 1),
              ),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // ── Countdown ring ─────────────────────────────────────────
                Stack(alignment: Alignment.center, children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4,
                      color: goldCol,
                      backgroundColor: borderCol,
                    ),
                  ),
                  Container(
                    width: 64,
                    height: 64,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: iconBg),
                    child: Center(
                      child: Text(
                        '$countdown',
                        style: TextStyle(
                            color: goldCol,
                            fontSize: 22,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 18),

                // ── Title ──────────────────────────────────────────────────
                Text(
                  'Still there?',
                  style: TextStyle(
                      color: textCol,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3),
                ),
                const SizedBox(height: 8),

                // ── Message ────────────────────────────────────────────────
                Text(
                  'You have been inactive for 4 minutes 30 seconds.\n'
                  'For your security, you will be automatically\n'
                  'signed out in $countdown seconds.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: mutedCol, fontSize: 12, height: 1.6),
                ),
                const SizedBox(height: 22),

                // ── Stay signed in ─────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      // Cancel timers, close dialog, restart full 5min timer
                      _cancelAll();
                      _dialogShowing = false;
                      Navigator.of(ctx).pop();
                      resetTimer();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: goldCol,
                      foregroundColor:
                          isDark ? AppColors.slateBase : AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'YES, KEEP ME SIGNED IN',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // ── Sign out now ───────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      _cancelAll();
                      _dialogShowing = false;
                      Navigator.of(ctx).pop();
                      onSessionExpired();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: mutedCol,
                      side: BorderSide(color: borderCol, width: 0.8),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Sign out now',
                        style: TextStyle(fontSize: 13)),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    ).then((_) {
      _dialogShowing = false;
    });
  }
}

// ── SessionAwareWrapper ───────────────────────────────────────────────────────
// Wraps the home screen and listens for tap/scroll to reset the timer
class SessionAwareWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onSessionExpired;

  const SessionAwareWrapper({
    super.key,
    required this.child,
    required this.onSessionExpired,
  });

  @override
  State<SessionAwareWrapper> createState() => _SessionAwareWrapperState();
}

class _SessionAwareWrapperState extends State<SessionAwareWrapper> {
  late SessionManager _sessionManager;

  @override
  void initState() {
    super.initState();
    _sessionManager = SessionManager(
      onSessionExpired: widget.onSessionExpired,
      getContext: () => context,
    );
    // Start the 5-minute inactivity timer immediately
    _sessionManager.resetTimer();
  }

  @override
  void dispose() {
    _sessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      // Reset timer on any tap
      onTap: _sessionManager.resetTimer,
      onPanDown: (_) => _sessionManager.resetTimer(),
      child: NotificationListener<ScrollNotification>(
        // Reset timer on any scroll
        onNotification: (_) {
          _sessionManager.resetTimer();
          return false;
        },
        child: widget.child,
      ),
    );
  }
}
