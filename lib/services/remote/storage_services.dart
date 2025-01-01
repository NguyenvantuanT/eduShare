import 'dart:io';

import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  final _storage = FirebaseStorage.instance;

  Future<String?> uploadUserImg(File file, String email) async {
    final snapshot =
        await _storage.ref("$email/Ava").child(email).putFile(file);
    try {
      return snapshot.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<String?> post({required File image, required String email}) async {
    return await uploadUserImg(image, email);
  }

  Future<String?> update({required File image}) async {
    String email = SharedPrefs.user?.email ?? "";
    await _storage.ref("$email/Ava").child(email).delete();
    return await uploadUserImg(image, email);
  }
}
