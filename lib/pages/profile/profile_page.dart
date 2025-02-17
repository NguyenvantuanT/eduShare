import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/app_dialog.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/pages/auth/change_password_page.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/pages/profile/profile_vm.dart';
import 'package:chat_app/pages/profile/widgets/information_card.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ProfilePage extends StackedView<ProfileVM> {
  const ProfilePage({super.key});

  @override
  ProfileVM viewModelBuilder(BuildContext context) => ProfileVM();

  @override
  void onViewModelReady(ProfileVM viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.onInit();
  }

  @override
  Widget builder(BuildContext context, ProfileVM viewModel, Widget? child) {
    return Scaffold(
        backgroundColor: AppColor.bgColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
              top: MediaQuery.of(context).padding.top + 50.0,
            ),
            child: Column(
              children: [
                _buildAvatar(viewModel),
                const SizedBox(height: 10.0),
                Text(
                  viewModel.nameController.text,
                  style: AppStyles.STYLE_20_BOLD.copyWith(
                    color: AppColor.textColor,
                  ),
                ),
                const SizedBox(height: 70.0),
                InformationCard(
                  icon: AppImages.iconProfile,
                  title: 'Username',
                  infor: viewModel.nameController.text,
                  onPressed: () => viewModel.editProfile(context)
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
                  infor: viewModel.emailController.text,
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
                      builder: (context) => const MainPage(index: 4,))),
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
                    onPressed: () => viewModel.updateProfile(context),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildAvatar(ProfileVM viewModel) {
    const radius = 50.0;
    return GestureDetector(
      onTap: viewModel.isLoading ? null : viewModel.pickAvatar,
      child: Stack(
        children: [
          viewModel.isLoading
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
              : viewModel.fileAvatar != null
                  ? CircleAvatar(
                      radius: radius,
                      backgroundImage: FileImage(File(viewModel.fileAvatar?.path ?? '')),
                    )
                  : viewModel.user.avatar != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(radius),
                          child: CachedNetworkImage(
                            imageUrl: viewModel.user.avatar ?? '',
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


