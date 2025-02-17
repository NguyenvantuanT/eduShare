import 'dart:io';

import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/components/text_field/app_text_field_password.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/auth/register_vm.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RegisterPage extends StackedView<RegisterVM>{
  const RegisterPage({super.key});

   @override
  RegisterVM viewModelBuilder(BuildContext context) => RegisterVM();
  

  @override
  Widget builder(BuildContext context, RegisterVM viewModel, Widget? child) {
   return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.bgColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(
            top: MediaQuery.of(context).padding.top + 50.0,
            bottom: 30.0,
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: viewModel.getImageFromGallery,
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.15,
                  backgroundImage: viewModel.fileAvatar != null
                      ? FileImage(viewModel.fileAvatar ?? File(''))
                      : const AssetImage("assets/images/default_ava.jpg")
                          as ImageProvider,
                ),
              ),
              Text(
                "Register",
                style: AppStyles.STYLE_28_BOLD.copyWith(
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 20.0),
              _formSignUp(viewModel),
              const SizedBox(height: 40.0),
              AppElevatedButton(
                text: "Register",
                isDisable: viewModel.isLoading,
                onPressed: () => viewModel.onSubmit(context),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Have an account? ",
                      style: AppStyles.STYLE_12
                          .copyWith(color: AppColor.textColor)),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    ),
                    behavior: HitTestBehavior.translucent,
                    child: Text('Login',
                        style: AppStyles.STYLE_14_BOLD
                            .copyWith(color: AppColor.blue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formSignUp(RegisterVM viewModel) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          AppTextField(
            controller: viewModel.usernameController,
            labelText: "Username",
            textInputAction: TextInputAction.next,
            validator: Validator.required,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: viewModel.emailController,
            labelText: "Email",
            textInputAction: TextInputAction.next,
            validator: Validator.email,
          ),
          const SizedBox(height: 20),
          AppTextFieldPassword(
            controller: viewModel.passwordController,
            labelText: "Password",
            textInputAction: TextInputAction.next,
            validator: Validator.password,
          ),
          const SizedBox(height: 20),
          AppTextFieldPassword(
            onChanged: (_) => viewModel.rebuildUi(),
            controller: viewModel.confirmPassController,
            labelText: "Confirm password",
            textInputAction: TextInputAction.done,
            validator:
                Validator.confirmPassword(viewModel.passwordController.text.trim()),
          ),
        ],
      ),
    );
  }

 
  
}

