import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field_password.dart';
import 'package:chat_app/pages/auth/change_password_vm.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

class ChangePasswordPage extends StackedView<ChangePasswordVM> {
  const ChangePasswordPage({super.key});

  @override
  ChangePasswordVM viewModelBuilder(BuildContext context) => ChangePasswordVM();

  @override
  Widget builder(
      BuildContext context, ChangePasswordVM viewModel, Widget? child) {
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
                  key: viewModel.formKey,
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
                          controller: viewModel.currentPasswordController,
                          labelText: 'Current Password',
                          validator: Validator.required,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 18.0),
                        AppTextFieldPassword(
                          controller: viewModel.newPasswordController,
                          labelText: 'New Password',
                          validator: Validator.password,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 18.0),
                        AppTextFieldPassword(
                          controller: viewModel.confirmPasswordController,
                          onChanged: (_) => viewModel.rebuildUi(),
                          labelText: 'Confirm Password',
                          validator: Validator.confirmPassword(
                              viewModel.newPasswordController.text),
                          onFieldSubmitted: (_) => viewModel.onSubmit(context),
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: 40.0),
                        AppElevatedButton(
                          onPressed: () => viewModel.onSubmit(context),
                          text: 'Done',
                          isDisable: viewModel.isLoading,
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
