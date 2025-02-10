import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/components/text_field/app_text_field_password.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/auth_services.dart';
import 'package:chat_app/services/remote/body/change_password_body.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                ],
              ),
            ),
            Positioned(
              left: 0.0,
              top: size.height / 3,
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Change Password',
                          style: AppStyles.STYLE_18.copyWith(
                            color: AppColor.textColor,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        AppTextFieldPassword(
                          controller: currentPasswordController,
                          labelText: 'Current Password',
                          validator: Validator.required,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 18.0),
                        AppTextFieldPassword(
                          controller: newPasswordController,
                          labelText: 'New Password',
                          validator: Validator.password,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 18.0),
                        AppTextFieldPassword(
                          controller: confirmPasswordController,
                          onChanged: (_) => setState(() {}),
                          labelText: 'Confirm Password',
                          validator: Validator.confirmPassword(
                              newPasswordController.text),
                          onFieldSubmitted: (_) => _onSubmit(context),
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: 40.0),
                        AppElevatedButton(
                          onPressed: () => _onSubmit(context),
                          text: 'Done',
                          isDisable: isLoading,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
