import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/remote/auth_services.dart';
import 'package:chat_app/services/remote/body/forgot_password_body.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.bgColor,
      body: Stack(
        children: [
          Positioned(
            left: 0.0,
            right: 0.0,
            top: MediaQuery.of(context).padding.top + 50.0,
            child: Column(
              children: [
                SvgPicture.asset(AppImages.imageLogo),
                const SizedBox(height: 20.0),
                Text(
                  'Welcome',
                  textAlign: TextAlign.center,
                  style: AppStyles.STYLE_28_BOLD.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0.0,
            top: size.height / 2.5,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              padding: const EdgeInsets.symmetric(horizontal: 20.0)
                  .copyWith(top: 50.0, bottom: 40.0),
              decoration: const BoxDecoration(
                color: AppColor.bgColor,
                boxShadow: AppShadow.boxShadow,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0)),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forgot Password',
                      style: AppStyles.STYLE_18.copyWith(
                        color: AppColor.textColor,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    AppTextField(
                      controller: emailController,
                      labelText: 'Username/Email',
                      textInputAction: TextInputAction.next,
                      validator: Validator.required,
                    ),
                    const SizedBox(height: 20.0),
                    
                    
                    const SizedBox(height: 40.0),
                    AppElevatedButton(
                      text: 'Send',
                      isDisable: isLoading,
                      onPressed: () {},
                    ),
                    
                  ],
                ),
              ),
            ),
          )
        ],
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
