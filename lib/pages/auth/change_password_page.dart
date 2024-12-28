import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/components/text_field/app_text_field_password.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/auth_services.dart';
import 'package:chat_app/services/remote/body/change_password_body.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthServices authServices = AuthServices();

  Future<void> _onSubmit(BuildContext context) async {
    if (formKey.currentState?.validate() == false) return;
    setState(() => isLoading = true);

    ChangePasswordBody body = ChangePasswordBody()
      ..email = SharedPrefs.user?.email ?? ""
      ..currentPassword = currentPasswordController.text.trim()
      ..newPassword = newPasswordController.text.trim();

    authServices.changePassword(body).then((value) {
      if (!context.mounted) return;
      if (value) {
        DelightToastShow.showToast(
          context: context,
          text: "Change Success !",
          icon: Icons.check,
        );
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(email: body.email)),
            (Route<dynamic> route) => false);
      } else {
        setState(() => isLoading = false);
        DelightToastShow.showToast(
          context: context,
          text: 'Current password is wrong😐',
          icon: Icons.check,
        );
      }
    }).catchError((_) {});
  }
  //ad
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(
                  top: MediaQuery.of(context).padding.top + 38.0, bottom: 16.0),
              children: [
                const Center(
                  child: Text('Change Password',
                      style: TextStyle(color: AppColor.black, fontSize: 24.0)),
                ),
                const SizedBox(height: 38.0),
                const Center(
                    child: Icon(
                  Icons.lock,
                  size: 30.0,
                )),
                const SizedBox(height: 46.0),
                AppTextFieldPassword(
                  controller: currentPasswordController,
                  hintText: 'Current Password',
                  validator: Validator.required,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 18.0),
                AppTextFieldPassword(
                  controller: newPasswordController,
                  hintText: 'New Password',
                  validator: Validator.password,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 18.0),
                AppTextFieldPassword(
                  controller: confirmPasswordController,
                  onChanged: (_) => setState(() {}),
                  hintText: 'Confirm Password',
                  validator:
                      Validator.confirmPassword(newPasswordController.text),
                  onFieldSubmitted: (_) => _onSubmit(context),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 92.0),
                AppElevatedButton.outline(
                  onPressed: () => _onSubmit(context),
                  text: 'Done',
                  isDisable: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
