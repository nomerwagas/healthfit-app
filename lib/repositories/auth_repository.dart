// lib/repositories/auth_repository.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../utils/env_config.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(
    clientId: EnvConfig.googleClientId.isNotEmpty ? EnvConfig.googleClientId : null,
  );

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
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final cred = await _auth.signInWithCredential(credential);
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
    await _googleSignIn.signOut().catchError((_) {});
    await _auth.signOut();
  }

  // ── Current User ──────────────────────────────────────────────────────────
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
