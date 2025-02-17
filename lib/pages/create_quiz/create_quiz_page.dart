import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/pages/create_quiz/create_quiz_vm.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CreateQuizPage extends StackedView<CreateQuizVM> {
  const CreateQuizPage({super.key, required this.courseId, this.onUpdate});

  final String courseId;
  final Function()? onUpdate;

  @override
  CreateQuizVM viewModelBuilder(BuildContext context) =>
      CreateQuizVM(courseId: courseId, onUpdate: onUpdate);

  @override
  Widget builder(BuildContext context, CreateQuizVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: const AppTabBarBlue(title: 'Create Quiz'),
      body: Form(
        key: viewModel.formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          children: [
            Text(
              'Question?',
              style:
                  AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
            ),
            const SizedBox(height: 10.0),
            AppTextField(
              controller: viewModel.questionController,
              labelText: "Write question?",
              textInputAction: TextInputAction.next,
              validator: Validator.required,
            ),
            const SizedBox(height: 20.0),
            Text(
              'Option one?',
              style:
                  AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
            ),
            const SizedBox(height: 10.0),
            AppTextField(
              controller: viewModel.optionOneController,
              labelText: "One...",
              textInputAction: TextInputAction.next,
              validator: Validator.required,
            ),
            const SizedBox(height: 20.0),
            Text(
              'Option two?',
              style:
                  AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
            ),
            const SizedBox(height: 10.0),
            AppTextField(
              controller: viewModel.optionTwoController,
              labelText: "Two...",
              textInputAction: TextInputAction.next,
              validator: Validator.required,
            ),
            const SizedBox(height: 20.0),
            Text(
              'Option three?',
              style:
                  AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
            ),
            const SizedBox(height: 10.0),
            AppTextField(
              controller: viewModel.optionThreeController,
              labelText: "Three...",
              textInputAction: TextInputAction.next,
              validator: Validator.required,
            ),
            const SizedBox(height: 20.0),
            Text(
              'Option four?',
              style:
                  AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
            ),
            const SizedBox(height: 10.0),
            AppTextField(
              controller: viewModel.optionFourController,
              labelText: "Four...",
              textInputAction: TextInputAction.next,
              validator: Validator.required,
            ),
            const SizedBox(height: 20.0),
            Text(
              'Option correct?',
              style:
                  AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
            ),
            const SizedBox(height: 10.0),
            AppTextField(
              controller: viewModel.optionCorrectController,
              labelText: "Correct...",
              textInputAction: TextInputAction.next,
              validator: Validator.required,
            ),
            const SizedBox(height: 20.0),
            FractionallySizedBox(
                widthFactor: 0.5,
                child: AppElevatedButton(
                  text: "Create Quiz",
                  onPressed: () => viewModel.createQuiz(context),
                ))
          ],
        ),
      ),
    );
  }
}

