import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/auth_services.dart';
import 'package:chat_app/services/remote/body/change_password_body.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ChangePasswordVM extends BaseViewModel {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthServices authServices = AuthServices();

  Future<void> onSubmit(BuildContext context) async {
    if (formKey.currentState?.validate() == false) return;
    isLoading = true;
    rebuildUi();

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
        isLoading = false;
        rebuildUi();
        DelightToastShow.showToast(
          context: context,
          text: 'Current password is wrong😐',
          icon: Icons.check,
        );
      }
    }).catchError((_) {});
  }
}