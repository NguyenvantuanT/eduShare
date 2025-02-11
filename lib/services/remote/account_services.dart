import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../local/shared_prefs.dart';

abstract class ImplAccountServices {
  Future<dynamic> getProfile(String email);
  Future<dynamic> updateProfile(UserModel body);
}

class AccountServices implements ImplAccountServices {
  @override
  Future<dynamic> getProfile(String email) async {
    try {
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users'); 
      DocumentSnapshot<Object?> snapshot =
          await userCollection.doc(email).get();
      SharedPrefs.user =
          UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<dynamic> updateProfile(UserModel body) async {
    UserModel user = SharedPrefs.user ?? UserModel();
    try {
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('users'); 
      await userCollection.doc(user.email).update(body.toJson());
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }
}
