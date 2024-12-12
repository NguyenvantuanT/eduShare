import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/components/text_field/app_text_field_password.dart';
import 'package:chat_app/pages/auth/forgot_password_page.dart';
import 'package:chat_app/pages/auth/sign_up_page.dart';
import 'package:chat_app/pages/main/home_page.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/services/remote/account_services.dart';
import 'package:chat_app/services/remote/auth_services.dart';
import 'package:chat_app/services/remote/body/login_body.dart';
import 'package:chat_app/themes/app_colors.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.email});
  final String? email;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  AuthServices authServices = AuthServices();
  AccountServices accountServices = AccountServices();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email ?? '';
  }

  Future<void> _submitLogin(BuildContext context) async {
    if (formKey.currentState?.validate() == false) return;
    setState(() => isLoading = true);
    LoginBody body = LoginBody()
      ..email = emailController.text.trim()
      ..password = passController.text.trim();

    authServices.login(body).then((_) {
      accountServices.getUser(body.email ?? '').then((_) {
        if (!context.mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
          (route) => false,
        );
      }).catchError((onError) {});
    }).catchError((onError) {
      if (!context.mounted) return;
      DelightToastShow.showToast(context: context, text: "Lofgin fail");
      accountServices.getUser(body.email ?? '').then((_) {
        if (!context.mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const MainPage(),
          ),
          (route) => false,
        );
      }).catchError((onError) {});
    }).whenComplete(() => setState(() => isLoading = true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.bgColor,
      body: _buildUI(context),
    );
  }

  Widget _buildUI(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Center(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20.0).copyWith(bottom: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _headerIcon(),
              _headerText(),
              const SizedBox(height: 20),
              _formLogin(context),
              const SizedBox(height: 10),
              _forgotPassword(),
              const SizedBox(height: 20),
              AppElevatedButton(
                text: "Login",
                isDisable: isLoading,
                onPressed: isLoading ? null : () => _submitLogin(context),
              ),
              const SizedBox(height: 10),
              _linkSignUp(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _linkSignUp(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have accout"),
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignUpPage())),
          behavior: HitTestBehavior.translucent,
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              "Sign Up?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  Widget _forgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
          ),
          behavior: HitTestBehavior.translucent,
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              "Forgot Password ?",
              style: TextStyle(fontSize: 15),
            ),
          ),
        )
      ],
    );
  }

  Widget _formLogin(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextField(
            controller: emailController,
            hintText: "Email",
            textInputAction: TextInputAction.next,
            validator: Validator.required,
            // validator: email,
          ),
          const SizedBox(height: 20),
          AppTextFieldPassword(
            controller: passController,
            hintText: "Pass",
            textInputAction: TextInputAction.done,
            validator: Validator.password,
            onFieldSubmitted: (_) => _submitLogin(context),
          ),
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
