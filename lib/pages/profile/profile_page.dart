import 'dart:io';
import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/app_dialog.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/auth/change_password_page.dart';
import 'package:chat_app/pages/course/course_page.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/pages/profile/widgets/information_card.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/account_services.dart';
import 'package:chat_app/services/remote/storage_services.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  StorageServices postImageServices = StorageServices();
  ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  File? fileAvatar;
  bool isLoading = false;
  UserModel user = SharedPrefs.user ?? UserModel();
  AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    nameController.text = user.name ?? '';
    emailController.text = user.email ?? '';
  }

  Future<void> pickAvatar() async {
    XFile? result = await picker.pickImage(source: ImageSource.gallery);
    if (result == null) return;
    fileAvatar = File(result.path);
    setState(() {});
  }

  Future<void> _updateProfile(BuildContext context) async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    final body = UserModel()
      ..name = nameController.text.trim()
      ..email = emailController.text.trim()
      ..avatar = fileAvatar != null
          ? await postImageServices.update(image: fileAvatar!)
          : SharedPrefs.user?.avatar ?? "";
    accountServices.updateProfile(body).then((_) {
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
              top: MediaQuery.of(context).padding.top + 50.0,
            ),
            child: Column(
              children: [
                _buildAvatar(),
                const SizedBox(height: 10.0),
                Text(
                  user.name ?? '',
                  style: AppStyles.STYLE_20_BOLD.copyWith(
                    color: AppColor.textColor,
                  ),
                ),
                const SizedBox(height: 70.0),
                InformationCard(
                  icon: AppImages.iconProfile,
                  title: 'Username',
                  infor: nameController.text,
                  onPressed: () async {
                    nameController.text = await AppDialog.editInformation(
                        context, nameController.text, AppImages.iconProfile);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20.0),
                InformationCard(
                  icon: AppImages.iconEmail,
                  title: 'Email',
                  type: const Icon(
                    Icons.lock,
                    color: AppColor.textColor,
                    size: 20.0,
                  ),
                  infor: emailController.text,
                ),
                const SizedBox(height: 20.0),
                InformationCard(
                  icon: AppImages.iconPassword,
                  title: 'Courses',
                  type: const Icon(
                    Icons.book,
                    color: AppColor.textColor,
                    size: 20.0,
                  ),
                  infor: 'Tab to get your courses',
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CoursePage())),
                ),
                const SizedBox(height: 20.0),
                InformationCard(
                  icon: AppImages.iconPassword,
                  title: 'Password',
                  type: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColor.textColor,
                    size: 13.0,
                  ),
                  infor: 'Tab to change password',
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage())),
                ),
                const SizedBox(height: 20.0),
                InformationCard(
                  icon: AppImages.iconPrivacy,
                  title: 'Logout',
                  infor: 'Tab to logout',
                  type: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColor.textColor,
                    size: 13.0,
                  ),
                  onPressed: () => AppDialog.confirmExitApp(context),
                ),
                const SizedBox(height: 50.0),
                FractionallySizedBox(
                  widthFactor: 0.6,
                  child: AppElevatedButton(
                    text: 'Save',
                    onPressed: () => _updateProfile(context),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildAvatar() {
    const radius = 50.0;
    return GestureDetector(
      onTap: isLoading ? null : pickAvatar,
      child: Stack(
        children: [
          isLoading
              ? const CircleAvatar(
                  radius: radius,
                  backgroundColor: AppColor.blue,
                  child: SizedBox.square(
                    dimension: 32.0,
                    child: CircularProgressIndicator(
                      color: AppColor.white,
                      strokeWidth: 2.0,
                    ),
                  ),
                )
              : fileAvatar != null
                  ? CircleAvatar(
                      radius: radius,
                      backgroundImage: FileImage(File(fileAvatar?.path ?? '')),
                    )
                  : user.avatar != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(radius),
                          child: CachedNetworkImage(
                            imageUrl: user.avatar ?? '',
                            fit: BoxFit.cover,
                            width: radius * 2,
                            height: radius * 2,
                            errorWidget: (context, __, ___) {
                              return Container(
                                width: radius * 2,
                                height: radius * 2,
                                color: AppColor.blue,
                                child: const Center(
                                  child: Icon(Icons.error_rounded,
                                      color: AppColor.white),
                                ),
                              );
                            },
                            placeholder: (context, __) {
                              return const SizedBox.square(
                                dimension: radius * 2,
                                child: Center(
                                  child: SizedBox.square(
                                    dimension: 26.0,
                                    child: CircularProgressIndicator(
                                      color: AppColor.white,
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
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey)),
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 14.6,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
