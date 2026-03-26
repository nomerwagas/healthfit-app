// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/user_model.dart';

// dart:io is only available on mobile/desktop – guard for web
import 'dart:io' if (dart.library.html) 'package:healthapp2/services/stub_io.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance;

  static CollectionReference get _users => _db.collection('users');

  // ── Create user profile ───────────────────────────────────────────────────
  static Future<void> createUser(UserModel user) async {
    await _users.doc(user.uid).set(user.toMap());
  }

  // ── Get user profile ──────────────────────────────────────────────────────
  static Future<UserModel?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  // ── Update user profile ───────────────────────────────────────────────────
  static Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _users.doc(uid).update(data);
  }

  // ── Upload profile picture ────────────────────────────────────────────────
  static Future<String> uploadProfilePicture(String uid, dynamic file) async {
    if (kIsWeb) {
      // File-based uploads not supported on web; use Uint8List upload instead.
      return '';
    }
    final ref = _storage.ref().child('profile_pictures/$uid.jpg');
    final task = await ref.putFile(
      file as File,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    return await task.ref.getDownloadURL();
  }

  // ── Toggle biometric preference ───────────────────────────────────────────
  static Future<void> setBiometricEnabled(String uid, bool enabled) async {
    await _users.doc(uid).update({'biometricEnabled': enabled});
  }

  // ── Stream user profile (real-time) ──────────────────────────────────────
  static Stream<UserModel?> streamUser(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    });
  }
}
