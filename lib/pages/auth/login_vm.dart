import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/services/remote/account_services.dart';
import 'package:chat_app/services/remote/auth_services.dart';
import 'package:chat_app/services/remote/body/login_body.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LoginVM extends BaseViewModel {
  LoginVM({this.email});
  final String? email;

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthServices authServices = AuthServices();
  AccountServices accountServices = AccountServices();
  bool isLoading = false;

  void onInit() {
    emailController.text = email ?? '';
  }

  Future<void> submitLogin(BuildContext context) async {
    if (formKey.currentState?.validate() == false) return;

    isLoading = true;
    rebuildUi();

    LoginBody body = LoginBody()
      ..email = emailController.text.trim()
      ..password = passwordController.text;

    authServices.login(body).then((_) {
      accountServices.getProfile(body.email ?? '').then((_) {
        if (!context.mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const MainPage(),
          ),
          (route) => false,
        );
      }).catchError((onError) {});
    }).catchError((onError) {
      if (!context.mounted) return;
      DelightToastShow.showToast(
        context: context,
        text: 'Email or Password is wrong😐',
      );
    }).whenComplete(() {
      isLoading = false;
      rebuildUi();
    });
  }
}
