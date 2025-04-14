import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/app_drop_down.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/models/quiz_model.dart';
import 'package:chat_app/pages/create_quiz/create_quiz_vm.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/enum.dart';
import 'package:chat_app/utils/extension.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CreateQuizPage extends StackedView<CreateQuizVM> {
  const CreateQuizPage({
    super.key,
    required this.courseId,
    this.quiz,
    this.onUpdate,
  });

  final String courseId;
  final QuizModel? quiz;
  final Function()? onUpdate;

  @override
  void onViewModelReady(CreateQuizVM viewModel) {
    viewModel.initializeQuizData();
  }

  @override
  CreateQuizVM viewModelBuilder(BuildContext context) => CreateQuizVM(
        courseId: courseId,
        quiz: quiz,
        onUpdate: onUpdate,
      );

  @override
  Widget builder(BuildContext context, CreateQuizVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: AppTabBarBlue(
        title: quiz == null ? 'Create Quiz' : 'Edit Quiz',
      ),
      body: Form(
        key: viewModel.formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          children: [
            Text(
              'Difficulty Level?',
              style:
                  AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
            ),
            const SizedBox(height: 10.0),
            AppDropDown<DifficultyLevel>(
              items: DifficultyLevel.values,
              selectedItem: viewModel.selectedDifficulty,
              onChanged: viewModel.choiceDifficulty,
              itemBuilder: (value) {
                return Text(
                  value.displayName,
                  style: AppStyles.STYLE_14.copyWith(color: AppColor.textColor),
                );
              },
            ),
            const SizedBox(height: 20.0),
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
                  value.displayName,
                  style: AppStyles.STYLE_14.copyWith(color: AppColor.textColor),
                );
              },
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question?',
                  style: AppStyles.STYLE_14_BOLD
                      .copyWith(color: AppColor.textColor),
                ),
                IconButton(
                  onPressed: () => _showSuggestionsModal(context, viewModel),
                  icon: const Icon(
                    Icons.lightbulb_outline,
                    color: AppColor.blue,
                    size: 20,
                  ),
                  tooltip: 'Suggest Questions',
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            AppTextField(
              maxLines: 4,
              controller: viewModel.questionController,
              labelText: "Write question?",
              textInputAction: TextInputAction.next,
              validator: Validator.required,
            ),
            const SizedBox(height: 20.0),
            Text(
              viewModel.selectedType == QuizType.qa ? 'Answer?' : 'Option?',
              style:
                  AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
            ),
            const SizedBox(height: 10.0),
            _buildWidgetQuizType(viewModel),
            const SizedBox(height: 20.0),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: AppElevatedButton(
                text: quiz == null ? "Create Quiz" : "Update Quiz",
                isDisable: viewModel.isLoading,
                onPressed: () => viewModel.createQuiz(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuggestionsModal(BuildContext context, CreateQuizVM viewModel) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      backgroundColor: AppColor.bgColor,
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Suggested Questions',
                style:
                    AppStyles.STYLE_16_BOLD.copyWith(color: AppColor.textColor),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.trivis.length,
                itemBuilder: (context, index) {
                  final trivia = viewModel.trivis[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    title: Text(
                      trivia.question ?? "",
                      style: AppStyles.STYLE_14.copyWith(
                        color: AppColor.textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Difficulty: ${trivia.difficulty}',
                              style: AppStyles.STYLE_12.copyWith(
                                color: AppColor.greyText,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Text(
                              'Type: ${trivia.type == 'multiple' ? 'single Choice' : 'True/False'}',
                              style: AppStyles.STYLE_12.copyWith(
                                color: AppColor.greyText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Answer: ${trivia.correctAnswer}',
                          style: AppStyles.STYLE_12.copyWith(
                            color: AppColor.greyText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    onTap: () {
                      viewModel.selectSuggestion(trivia);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWidgetQuizType(CreateQuizVM viewModel) {
    switch (viewModel.selectedType) {
      case QuizType.singleChoice:
        return _buildSingleChoice(viewModel);
      case QuizType.multipleChoice:
        return _buildMultipleChoice(viewModel);
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

  Widget _buildSingleChoice(CreateQuizVM viewModel) {
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
                  fillColor: MaterialStateProperty.resolveWith<Color>(
                    (_) => AppColor.blue),
                onChanged: (value) {
                  viewModel.correctOptionIndex = value;
                  viewModel.rebuildUi();
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMultipleChoice(CreateQuizVM viewModel) {
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
                fillColor: MaterialStateProperty.resolveWith<Color>(
                    (_) => AppColor.blue),
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
