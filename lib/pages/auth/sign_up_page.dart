import 'dart:io';
import 'dart:developer' as dev;

import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/components/text_field/app_text_field_password.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/services/remote/auth_services.dart';
import 'package:chat_app/services/remote/body/resigter_body.dart';
import 'package:chat_app/services/remote/storage_services.dart';
import 'package:chat_app/themes/app_colors.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  StorageServices postImageServices = StorageServices();
  AuthServices authServices = AuthServices();

  ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  File? fileAvatar;

  Future<void> getImageFromGallery() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    fileAvatar = File(file.path);
    setState(() {});
  }

  Future<void> onSubmit(BuildContext context) async {
    if (formKey.currentState?.validate() == false) return;
    setState(() => isLoading = true);
    ResigterBody body = ResigterBody()
      ..name = usernameController.text.trim()
      ..email = emailController.text.trim()
      ..password = emailController.text.trim()
      ..confirmPass = confirmPassController.text.trim()
      ..avatar = fileAvatar != null
          ? await postImageServices.post(image: fileAvatar!)
          : null;
    authServices.resigter(body).then((_) {
      if (!context.mounted) return;
      DelightToastShow.showToast(
        context: context,
        text: "Sign Up Success",
        icon: Icons.check,
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginPage(email: body.email ?? ''),
        ),
        (Route<dynamic> route) => false,
      );
    }).catchError((error) {
      dev.log("Failed to register: $error");
      if (!context.mounted) return;
      DelightToastShow.showToast(
        context: context,
        text: 'Server error 😐',
        icon: Icons.error,
      );
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
              _headerAvata(),
              _headerTitle(),
              const SizedBox(height: 20),
              _formSignUp(),
              const SizedBox(height: 10),
              _forgotPassword(),
              const SizedBox(height: 20),
              AppElevatedButton(
                text: "Register",
                isDisable: isLoading,
                onPressed: () => onSubmit(context),
              ),
              const SizedBox(height: 10),
              _linkLogin(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _linkLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Alredy have accout"),
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginPage())),
          behavior: HitTestBehavior.translucent,
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              "Login?",
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
          onTap: () {},
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

  Widget _formSignUp() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextField(
            controller: usernameController,
            hintText: "Username",
            textInputAction: TextInputAction.next,
            validator: Validator.required,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: emailController,
            hintText: "Email",
            textInputAction: TextInputAction.next,
            validator: Validator.email,
          ),
          const SizedBox(height: 20),
          AppTextFieldPassword(
            controller: passwordController,
            hintText: "Pass",
            textInputAction: TextInputAction.next,
            validator: Validator.password,
          ),
          const SizedBox(height: 20),
          AppTextFieldPassword(
            onChanged: (_) => setState(() {}),
            controller: confirmPassController,
            hintText: "Confirm password",
            textInputAction: TextInputAction.done,
            validator:
                Validator.confirmPassword(passwordController.text.trim()),
          ),
        ],
      ),
    );
  }

  Widget _headerTitle() {
    return const Text(
      "S I G N U P",
      style: TextStyle(fontSize: 22),
    );
  }

  Widget _headerAvata() {
    return GestureDetector(
      onTap: getImageFromGallery,
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: fileAvatar != null
            ? FileImage(fileAvatar ?? File(''))
            : const AssetImage("assets/images/default_ava.jpg")
                as ImageProvider,
      ),
    );
  }

  //nguyenvantuan487t@gmail.com pass 1234567
  //vtinter@gmail.com pass 1234567
  //cun@gmail.com pass 1234567
}
