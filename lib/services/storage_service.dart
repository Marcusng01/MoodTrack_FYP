import 'dart:io';

import 'package:ai_mood_tracking_application/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final AuthService _auth = AuthService();
  User? get currentUser => _auth.currentUser;
  late String imageUrl;

  Future<void> uploadImage(File imageFile) async {
    Reference ref = _storage
        .ref()
        .child('profile_pictures')
        .child('currentUser!.uid')
        .child('${imageFile.hashCode}.jpg');

    UploadTask uploadTask = ref.putFile(imageFile);
    await uploadTask.whenComplete(() async {
      imageUrl = await ref.getDownloadURL();
    });
  }
}
