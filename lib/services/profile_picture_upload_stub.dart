import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadProfilePictureToStorage(Reference ref, dynamic file) async {
  // Web build: we don’t support File-based uploads here.
  //
  // If you want web uploads, pass `Uint8List` bytes from `image_picker_for_web`
  // and implement `ref.putData(bytes, ...)` in this stub.
  return '';
}

