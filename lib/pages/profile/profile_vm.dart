import 'dart:io';

import 'package:chat_app/components/app_dialog.dart';
import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/account_services.dart';
import 'package:chat_app/services/remote/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class ProfileVM extends BaseViewModel {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  StorageServices postImageServices = StorageServices();
  AccountServices accountServices = AccountServices();
  UserModel user = SharedPrefs.user ?? UserModel();
  final formKey = GlobalKey<FormState>();
  ImagePicker picker = ImagePicker();
  bool isLoading = false;
  File? fileAvatar;

  void onInit() {
    nameController.text = user.name ?? '';
    emailController.text = user.email ?? '';
  }

  void editProfile(BuildContext context) async {
    nameController.text = await AppDialog.editInformation(
        context, nameController.text, AppImages.iconProfile);
    rebuildUi();
  }

  Future<void> pickAvatar() async {
    XFile? result = await picker.pickImage(source: ImageSource.gallery);
    if (result == null) return;
    fileAvatar = File(result.path);
    rebuildUi();
  }

  Future<void> updateProfile(BuildContext context) async {
    isLoading = true;
    rebuildUi();
    await Future.delayed(const Duration(milliseconds: 1000));
    final body = UserModel()
      ..name = nameController.text.trim()
      ..email = emailController.text.trim()
      ..avatar = fileAvatar != null
          ? await postImageServices.post(image: fileAvatar!)
          : SharedPrefs.user?.avatar ?? "";
    accountServices.updateProfile(body).then((_) {
      SharedPrefs.user = body;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DelightToastShow.showToast(
          context: context,
          text: 'Profile has been saved 😍',
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
          (Route<dynamic> route) => false,
        );
      });
    }).catchError((onError) {
      dev.log("Failed to update Profile: $onError");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        DelightToastShow.showToast(
          context: context,
          text: 'Profile has been saved 😍',
        );
        isLoading = false;
        rebuildUi();
      });
    });
  }
}
