import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/app_drop_down.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/pages/create_quiz/create_quiz_vm.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/enum.dart';
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
              'Type Question?',
              style:
                  AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
            ),
            const SizedBox(height: 10.0),
            AppDropDown<QuizType>(
              items: QuizType.values,
              selectedItem: viewModel.selectedType,
              onChanged: viewModel.choiceQuizType,
              itemBuilder: (value) {
                return Text(
                  value.name,
                  style: AppStyles.STYLE_14.copyWith(color: AppColor.textColor),
                );
              },
            ),
            const SizedBox(height: 20.0),
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
              'Option ?',
              style:
                  AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
            ),
            const SizedBox(height: 10.0),
            _buildWidgetQuizType(viewModel),
            const SizedBox(height: 20.0),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: AppElevatedButton(
                text: "Create Quiz",
                onPressed: () => viewModel.createQuiz(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetQuizType(CreateQuizVM viewModel) {
    switch (viewModel.selectedType) {
      case QuizType.singleChoice:
        return _buildSiglerChoice(viewModel);
      case QuizType.multipleChoice:
        return _buildmultipleChoice(viewModel);
      default:
        return _buildQAChoice(viewModel);
    }
  }

  Widget _buildQAChoice(CreateQuizVM viewModel) {
    return Column(
      children: [
        AppTextField(
          controller: viewModel.correctAnswerController,
          labelText: "Correct Answer",
          validator: (value) => value!.isEmpty ? "Answer is required" : null,
        ),
      ],
    );
  }

  Widget _buildSiglerChoice(CreateQuizVM viewModel) {
    return Column(
      children: List.generate(4, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: viewModel.optionControllers[index],
                  labelText: "Option ${index + 1}",
                  validator: Validator.required,
                ),
              ),
              const SizedBox(width: 10),
              Radio<int>(
                value: index,
                groupValue: viewModel.correctOptionIndex,
                onChanged: (value) {
                  viewModel.correctOptionIndex = value;
                  viewModel.rebuildUi();
                },
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildmultipleChoice(CreateQuizVM viewModel) {
    return Column(
      children: List.generate(4, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: viewModel.optionControllers[index],
                  labelText: "Option ${index + 1}",
                  validator: Validator.required,
                ),
              ),
              const SizedBox(width: 10),
              Checkbox(
                value: viewModel.correctOptionIndices.contains(index),
                onChanged: (checked) {
                  if (checked == true) {
                    viewModel.correctOptionIndices.add(index);
                  } else {
                    viewModel.correctOptionIndices.remove(index);
                  }
                  viewModel.rebuildUi();
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
