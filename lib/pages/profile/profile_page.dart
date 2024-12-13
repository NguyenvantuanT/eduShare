import 'dart:io';
import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/account_services.dart';
import 'package:chat_app/services/remote/storage_services.dart';
import 'package:chat_app/themes/app_colors.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  StorageServices postImageServices = StorageServices();
  ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  File? fileAvatar;
  bool isLoading = false;
  dynamic user = SharedPrefs.user ?? UserModel();
  AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
  }

  Future<void> pickAvatar() async {
    XFile? result = await picker.pickImage(source: ImageSource.gallery);
    if (result == null) return;
    fileAvatar = File(result.path);
    setState(() {});
  }

  Future<void> _updateProfile(BuildContext context) async {
    if (formKey.currentState!.validate() == false) return;
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    final body = UserModel()
      ..name = nameController.text.trim()
      ..email = emailController.text.trim()
      ..avatar = fileAvatar != null
          ? await postImageServices.post(image: fileAvatar!)
          : SharedPrefs.user?.avatar ?? "";
    accountServices.updateUser(body).then((_) {
      SharedPrefs.user = body;
      if (!context.mounted) return;
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
    }).catchError((onError) {
      dev.log("Failed to update Profile: $onError");
      if (!context.mounted) return;
      DelightToastShow.showToast(
        context: context,
        text: 'Profile has been saved 😍',
      );
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(
            top: MediaQuery.of(context).padding.top + 38.0, bottom: 50.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const Text(
                "Profile",
                style: TextStyle(color: AppColor.orange, fontSize: 24.6),
              ),
              const SizedBox(height: 20.0),
              Container(
                width: MediaQuery.of(context).size.width - 20.0,
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: _buildAvatar(),
              ),
              const SizedBox(height: 20.0),
              AppTextField(
                readOnly: true,
                hintText: "Email",
                prefixIcon: const Icon(Icons.email, color: AppColor.grey),
                controller: emailController,
              ),
              const SizedBox(height: 20.0),
              AppTextField(
                hintText: "Full Name",
                controller: nameController,
                validator: Validator.required,
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.person, color: AppColor.grey),
              ),
              const Spacer(),
              AppElevatedButton(
                text: "Update",
                isDisable: isLoading,
                onPressed: () => _updateProfile(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    const radius = 50.0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isLoading
            ? Container(
                width: radius * 2,
                height: radius * 2,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.orange.shade200,
                ),
                child: const SizedBox.square(
                      dimension: 32.0,
                      child: CircularProgressIndicator(
                        color: AppColor.pink,
                        strokeWidth: 2.0,
                      ),
                    ),
              )
            : fileAvatar != null
                ? Container(
                    width: radius * 2,
                    height: radius * 2,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0)),
                      color: AppColor.bgColor,
                      image: DecorationImage(
                        image: FileImage(File(fileAvatar?.path ?? '')),
                      ),
                    ),
                  )
                : user.avatar != null
                    ? ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20.0)),
                        child: CachedNetworkImage(
                          imageUrl: SharedPrefs.user?.avatar ?? "",
                          fit: BoxFit.cover,
                          width: radius * 2,
                          height: radius * 2,
                          errorWidget: (context, error, stackTrace) {
                            return Container(
                              width: radius * 2,
                              height: radius * 2,
                              color: AppColor.orange,
                              child: const Center(
                                child: Icon(Icons.error_rounded,
                                    color: AppColor.white),
                              ),
                            );
                          },
                          placeholder: (_, __) {
                            return const SizedBox.square(
                              dimension: radius * 2,
                              child: Center(
                                child: SizedBox.square(
                                  dimension: 26.0,
                                  child: CircularProgressIndicator(
                                    color: AppColor.pink,
                                    strokeWidth: 2.0,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : const CircleAvatar(
                        radius: radius,
                        backgroundImage:
                            // Assets.images.defaultAvatar.provider()
                            AssetImage("assets/images/default_ava.jpg"),
                      ),
        const SizedBox(width: 30.0),
        GestureDetector(
          onTap: () => pickAvatar(),
          child: Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              color: AppColor.grey.withOpacity(0.4),
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              size: 30.0,
              color: AppColor.grey,
            ),
          ),
        )
      ],
    );
  }
}
