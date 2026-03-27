// lib/repositories/auth_repository.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  // On Android/iOS, rely on google-services/plist config.
  // Passing web clientId here can break native sign-in.
  final _googleSignIn = GoogleSignIn();

  // ── Validators ────────────────────────────────────────────────────────────
  static String? validateEmail(String email) {
    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(email)) return 'Enter a valid email address';
    return null;
  }

  static String? validatePassword(String password) {
    // Strong password: min 8 chars, uppercase, lowercase, digit, special char
    if (password.length < 8) return 'Password must be at least 8 characters';
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Must contain an uppercase letter';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Must contain a lowercase letter';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Must contain a number';
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Must contain a special character';
    }
    return null;
  }

  // ── Email/Password Registration ───────────────────────────────────────────
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    required int age,
    required double weight,
    String? city,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await cred.user?.updateDisplayName(fullName);

    final user = UserModel(
      uid: cred.user!.uid,
      fullName: fullName,
      email: email,
      age: age,
      weight: weight,
      city: city,
    );

    await FirestoreService.createUser(user);
    await StorageService.saveUserEmail(email);
    await StorageService.saveLastLogin(DateTime.now());

    return user;
  }

  // ── Email/Password Login ──────────────────────────────────────────────────
  Future<UserModel?> loginWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await StorageService.saveUserEmail(email);
    await StorageService.saveLastLogin(DateTime.now());

    return await FirestoreService.getUser(cred.user!.uid);
  }

  // ── Google Sign-In ────────────────────────────────────────────────────────
  Future<UserModel?> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      provider.setCustomParameters({'prompt': 'select_account'});
      try {
        // Prefer popup on web so sign-in can complete in one flow.
        final cred = await _auth.signInWithPopup(provider);
        return _saveGoogleUser(cred);
      } on FirebaseAuthException catch (e) {
        // Some browsers/environments block popups; fallback to redirect.
        if (e.code == 'popup-blocked' ||
            e.code == 'web-context-cancelled' ||
            e.code == 'operation-not-supported-in-this-environment') {
          await _auth.signInWithRedirect(provider);
          return null; // Redirect result will be completed on next load.
        }
        rethrow;
      }
    }

    // Mobile Google Sign-In Flow
    // Clear cached Google account so the chooser appears every time.
    await _googleSignIn.signOut().catchError((_) {});
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final cred = await _auth.signInWithCredential(credential);
    return await _saveGoogleUser(cred);
  }

  // Called once on app startup (web only) to complete the Firebase redirect.
  // Returns true if a pending redirect was found and the user was signed in.
  Future<bool> completeWebRedirect() async {
    if (!kIsWeb) return false;
    try {
      final cred = await _auth.getRedirectResult();
      if (cred.user == null) return false;
      // Keep auth state responsive even if profile save fails.
      _saveGoogleUser(cred).catchError((_) => null);
      return true;
    } catch (e) {
      // Log error but don't block auth state
      // ignore: avoid_print
      print('[Auth] getRedirectResult error: $e');
      return false;
    }
  }

  // Keep old name for compatibility
  Future<UserModel?> getWebRedirectResult() => completeWebRedirect().then((_) => null);

  Future<UserModel?> _saveGoogleUser(UserCredential cred) async {
    final uid = cred.user!.uid;

    // Check if user already exists in Firestore
    UserModel? existing = await FirestoreService.getUser(uid);
    if (existing != null) {
      await StorageService.saveLastLogin(DateTime.now());
      return existing;
    }

    // Create new profile for first-time Google users
    final newUser = UserModel(
      uid: uid,
      fullName: cred.user!.displayName ?? 'User',
      email: cred.user!.email ?? '',
      age: 25,
      weight: 60.0,
      profilePictureUrl: cred.user!.photoURL,
    );

    await FirestoreService.createUser(newUser);
    await StorageService.saveUserEmail(newUser.email);
    await StorageService.saveLastLogin(DateTime.now());

    return newUser;
  }

  // ── Sign Out ──────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await _googleSignIn.disconnect().catchError((_) {});
    await _googleSignIn.signOut().catchError((_) {});
    await _auth.signOut();
  }

  // ── Current User ──────────────────────────────────────────────────────────
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
