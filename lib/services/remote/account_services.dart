import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ImplAccountServices {
  Future<void> getUser(String email);
  Future<void> updateUser(UserModel user);
}


class AccountServices implements ImplAccountServices {

  @override
  Future<void> getUser(String email) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot<Object?> data = await userCollection.doc(email).get();
    print(data.data());
    SharedPrefs.user = UserModel.fromJson(data.data() as Map<String,dynamic>);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    UserModel user = SharedPrefs.user ?? UserModel();
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    await userCollection.doc(user.email).update(user.toJson());
  }

}