import 'dart:io';

import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  final _storage = FirebaseStorage.instance;
  String email = SharedPrefs.user?.email ?? "";

  Future<String?> uploadUserImg(File file) async {
   final now = DateTime.now();
    String path =
        DateTime(now.year, now.month, now.day, now.hour, now.minute).toString();
    final snapshot = await _storage.ref("$email/Ava").child(path).putFile(file);
    try {
      return snapshot.ref.getDownloadURL();
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> post({required File image}) async {
    return await uploadUserImg(image);
  }


  Future<String?> uploadFile(String fileName , File file) async {
    
    final snapshot = await _storage.ref("$email/File").child('$fileName.pdf').putFile(file);
    try {
      return snapshot.ref.getDownloadURL();
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> postFile({required String fileName , required File file}) async {
    return await uploadUserImg(file);
  }
}
