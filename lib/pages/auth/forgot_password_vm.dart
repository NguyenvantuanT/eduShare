import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/services/remote/auth_services.dart';
import 'package:chat_app/services/remote/body/forgot_password_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordVM extends BaseViewModel {
  final emailController = TextEditingController();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  AuthServices authServices = AuthServices();

  Future<void> onSubmit(BuildContext context) async {
    if (formKey.currentState!.validate() == false) return;

    isLoading = true;
    rebuildUi();
    await Future.delayed(const Duration(milliseconds: 1200));

    ForgotPasswordBody body = ForgotPasswordBody()
      ..email = emailController.text.trim();
    authServices.forgotPassword(body).then((_) {
      if (!context.mounted) return;
      DelightToastShow.showToast(
        context: context,
        text: "Check your email and change pass",
      );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(email: body.email)),
          (Route<dynamic> route) => false);
    }).catchError((error) {
      FirebaseAuthException a = error as FirebaseAuthException;
      if (!context.mounted) return;
      DelightToastShow.showToast(
        context: context,
        text: a.message ?? "",
      );
    }).whenComplete(() {
      isLoading = false;
      rebuildUi();
    });
  }
}