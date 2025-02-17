import 'dart:io';

import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/services/remote/auth_services.dart';
import 'package:chat_app/services/remote/body/resigter_body.dart';
import 'package:chat_app/services/remote/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class RegisterVM extends BaseViewModel {
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
    rebuildUi();
  }

  Future<void> onSubmit(BuildContext context) async {
    if (formKey.currentState!.validate() == false) {
      return;
    }
    isLoading = true;
    rebuildUi();

    RegisterBody body = RegisterBody()
      ..name = usernameController.text.trim()
      ..email = emailController.text.trim()
      ..password = passwordController.text
      ..avatar = fileAvatar != null
          ? await postImageServices.post(image: fileAvatar!)
          : null;

    authServices.register(body).then((_) {
      if (!context.mounted) return;
      DelightToastShow.showToast(
        context: context,
        text: 'Register successfully, please login 😍',
      );

      Navigator.of(context)
          .pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => LoginPage(email: body.email ?? ''),
            ),
            (Route<dynamic> route) => false,
          )
          .catchError((error) {});
    }).catchError((error) {
      dev.log("Failed to register: $error");
      if (!context.mounted) return;
      DelightToastShow.showToast(
        context: context,
        text: 'Server error 😐',
      );
    }).whenComplete(() {
      isLoading = false;
      rebuildUi();
    });
  }
}
