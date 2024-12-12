import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  final _storage = FirebaseStorage.instance;
  Future<String?> uploadUserImg(File file) async {
    final now = DateTime.now();
    String path =
        DateTime(now.year, now.month, now.day, now.hour, now.minute).toString();

    final snapshot = await _storage.ref("users/Ava").child(path).putFile(file);
    try {
      return snapshot.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<String?> post({required File image}) async {
    return await uploadUserImg(image);
  }
}
