import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/services/remote/auth_services.dart';
import 'package:chat_app/services/remote/body/forgot_password_body.dart';
import 'package:chat_app/themes/app_colors.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  AuthServices authServices = AuthServices();

  Future<void> _onSubmit(BuildContext context) async {
    if (formKey.currentState!.validate() == false) return;

    setState(() => isLoading = true);
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
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(
            top: MediaQuery.of(context).padding.top + 130.0, bottom: 50.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _headerIcon(),
              _headerText(),
              const SizedBox(height: 10.0),
              AppTextField(
                controller: emailController,
                hintText: "Email",
                validator: Validator.email,
              ),
              const SizedBox(height: 30.0),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: AppElevatedButton(
                  text: "Next",
                  onPressed: () => _onSubmit(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerText() {
    return const Text(
      "V T I N T E R",
      style: TextStyle(fontSize: 22),
    );
  }

  Icon _headerIcon() {
    return const Icon(
      Icons.person,
      color: AppColor.grey,
      size: 80,
    );
  }
}
