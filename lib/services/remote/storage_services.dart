import 'dart:io';

import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  final _storage = FirebaseStorage.instance;
  String email = SharedPrefs.user?.email ?? "";
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
    
    await _storage.ref("$email/Ava").child(email).delete();
    return await uploadUserImg(image, email);
  }


  Future<String?> uploadUserImgCourse(File file , String id) async {
    final snapshot =
        await _storage.ref("$email/courses").child('$email-$id').putFile(file);
    try {
      return snapshot.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<String?> postImgeCourse({required File image, required String id}) async {
    return await uploadUserImgCourse(image,id);
  }

  Future<String?> uploadUserVideo(File file, String id) async {
    final snapshot =
        await _storage.ref("$email/courses/video").child('$email-$id').putFile(file);
    try {
      return snapshot.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<String?> postVideo({required File image, required String id}) async {
    return await uploadUserVideo(image, id);
  }
}
