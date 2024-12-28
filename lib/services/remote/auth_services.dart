import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/remote/body/change_password_body.dart';
import 'package:chat_app/services/remote/body/forgot_password_body.dart';
import 'package:chat_app/services/remote/body/login_body.dart';
import 'package:chat_app/services/remote/body/resigter_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ImplAuthServices {
  Future<dynamic> login(LoginBody body);
  Future<dynamic> resigter(ResigterBody body);
  Future<dynamic> forgotPassword(ForgotPasswordBody body);
  Future<bool> changePassword(ChangePasswordBody body);
}

class AuthServices implements ImplAuthServices {
  @override
  Future<dynamic> login(LoginBody body) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: body.email ?? '',
      password: body.password ?? '',
    );
  }

  @override
  Future<dynamic> resigter(ResigterBody body) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: body.email ?? "",
      password: body.password ?? "",
    );

    UserModel user = UserModel()
      ..avatar = body.avatar ?? ""
      ..name = body.name ?? ""
      ..email = body.email ?? "";

    await userCollection.doc(user.email).set(user.toJson());
  }

  @override
  Future<bool> changePassword(ChangePasswordBody body) async {
    try {
      final loginUser = FirebaseAuth.instance.currentUser;
      final credential = EmailAuthProvider.credential(
        email: body.email ?? '',
        password: body.currentPassword ?? '',
      );
      await loginUser?.reauthenticateWithCredential(credential);
      await loginUser?.updatePassword(body.newPassword ?? '');
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<dynamic> forgotPassword(ForgotPasswordBody body) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: body.email ?? '');
  }
}
