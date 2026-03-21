// lib/services/cloudinary_service.dart
// Supports Flutter Web (browser) AND Mobile (Android/iOS)
// Uses unsigned upload preset — no API secret needed in app

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  static const String _cloudName = 'dutu6kcf6';
  static const String _uploadPreset = 'healthfit_preset';

  static String get _uploadUrl =>
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

  // ── Upload profile picture from XFile ─────────────────────────────────────
  // XFile works on both Flutter Web and Mobile — no dart:io needed
  static Future<String> uploadProfilePictureFromXFile(
      String uid, XFile xFile) async {
    final Uint8List bytes = await xFile.readAsBytes();
    final String fileName = 'profile_$uid.jpg';

    final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));

    // Only upload_preset and folder are allowed for unsigned uploads
    // Do NOT add: overwrite, public_id, transformation (blocked by Cloudinary)
    request.fields['upload_preset'] = _uploadPreset;
    request.fields['folder'] = 'profile_pictures';

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: fileName,
    ));

    final streamedResponse =
        await request.send().timeout(const Duration(seconds: 30));
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['secure_url'] as String;
    } else {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final msg = body['error']?['message'] ?? 'Status ${response.statusCode}';
      throw Exception('Upload failed: $msg');
    }
  }
}
