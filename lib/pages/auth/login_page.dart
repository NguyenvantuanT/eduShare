import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/components/text_field/app_text_field_password.dart';
import 'package:chat_app/pages/auth/forgot_password_page.dart';
import 'package:chat_app/pages/auth/register_page.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/remote/account_services.dart';
import 'package:chat_app/services/remote/auth_services.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/services/remote/body/login_body.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.email});
  final String? email;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthServices authServices = AuthServices();
  AccountServices accountServices = AccountServices();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email ?? '';
  }

  Future<void> _submitLogin(BuildContext context) async {
    if (formKey.currentState?.validate() == false) {
      return;
    }
    setState(() => isLoading = true);

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
    }).whenComplete(
      () => setState(() => isLoading = false),
    );
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
                boxShadow: AppShadow.boxShadowLogin,
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
                      'Login',
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
                    AppTextFieldPassword(
                      controller: passwordController,
                      labelText: 'Password',
                      textInputAction: TextInputAction.done,
                      validator: Validator.password,
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage()),
                          ),
                          child: Text(
                            'Forgot password?',
                            style: AppStyles.STYLE_14.copyWith(
                              color: AppColor.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40.0),
                    AppElevatedButton(
                      text: 'Login',
                      isDisable: isLoading,
                      onPressed: () => _submitLogin(context),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account, ',
                            style: AppStyles.STYLE_12
                                .copyWith(color: AppColor.textColor)),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          ),
                          behavior: HitTestBehavior.translucent,
                          child: Text('Register',
                              style: AppStyles.STYLE_14_BOLD
                                  .copyWith(color: AppColor.blue)),
                        ),
                      ],
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
}
