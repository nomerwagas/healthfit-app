import 'package:firebase_storage/firebase_storage.dart';

import 'profile_picture_upload_stub.dart'
    if (dart.library.io) 'profile_picture_upload_io.dart' as impl;

Future<String> uploadProfilePictureToStorage(
  Reference ref,
  dynamic file,
) =>
    impl.uploadProfilePictureToStorage(ref, file);

