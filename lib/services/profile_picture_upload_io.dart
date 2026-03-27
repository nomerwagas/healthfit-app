import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadProfilePictureToStorage(Reference ref, dynamic file) async {
  final task = await ref.putFile(
    file as File,
    SettableMetadata(contentType: 'image/jpeg'),
  );
  return task.ref.getDownloadURL();
}

