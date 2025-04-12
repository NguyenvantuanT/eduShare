import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/pages/quiz/quiz_vm.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class QuizPage extends StackedView<QuizVM> {
  const QuizPage(this.couseId, {super.key, this.level});
  final String couseId;
  final DifficultyLevel? level;

  @override
  void onViewModelReady(QuizVM viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.onInit();
  }

  @override
  QuizVM viewModelBuilder(BuildContext context) =>
      QuizVM(couseId: couseId, level: level);

  @override
  Widget builder(BuildContext context, QuizVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: const AppTabBarBlue(title: 'Quiz'),
      body: viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColor.blue,
              ),
            )
          : viewModel.quizs.isEmpty
              ? Center(
                  child: Text(
                    "No Quiz yet!",
                    style: AppStyles.STYLE_20.copyWith(color: AppColor.blue),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: (viewModel.currentIndex + 1) /
                            viewModel.quizs.length,
                        backgroundColor: AppColor.grey,
                        color: AppColor.blue,
                        minHeight: 8,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        width: double.infinity,
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: AppShadow.boxShadowContainer,
                        ),
                        child: Text(
                          viewModel.quizs[viewModel.currentIndex].question ??
                              '',
                          textAlign: TextAlign.center,
                          style:
                              AppStyles.STYLE_14.copyWith(color: AppColor.blue),
                        ),
                      ),
                      Expanded(
                        child: _buildQuestionContent(context, viewModel),
                      ),
                      if (viewModel.hasAnswered)
                        AppElevatedButton(
                          onPressed: () => viewModel.nextQuestion(context),
                          text: viewModel.currentIndex ==
                                  viewModel.quizs.length - 1
                              ? 'Finish'
                              : 'Next',
                        ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
    );
  }

  Widget _buildQuestionContent(BuildContext context, QuizVM viewModel) {
    final quiz = viewModel.quizs[viewModel.currentIndex];
    switch (quiz.type) {
      case QuizType.singleChoice:
        return ListView.separated(
          itemCount: quiz.options?.length ?? 0,
          separatorBuilder: (_, __) => const SizedBox(height: 15.0),
          itemBuilder: (context, index) {
            return _buildSingleChoiceOption(index, viewModel);
          },
        );
      case QuizType.multipleChoice:
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: quiz.options?.length ?? 0,
                separatorBuilder: (_, __) => const SizedBox(height: 15.0),
                itemBuilder: (context, index) {
                  return _buildMultipleChoiceOption(index, viewModel);
                },
              ),
            ),
            if (!viewModel.hasAnswered)
              AppElevatedButton(
                text: 'Submit',
                onPressed: () {
                  if (viewModel.selectedOptions.isNotEmpty) {
                    viewModel.checkAnswer(viewModel.selectedOptions);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please select at least one option')),
                    );
                  }
                },
              ),
          ],
        );
      case QuizType.qa:
        return Column(
          children: [
            AppTextField(
              labelText: 'Your Answer',
              // enabled: !viewModel.hasAnswered,
              onChanged: (value) {
                viewModel.qaAnswer = value;
              },
            ),
            const SizedBox(height: 20.0),
            if (!viewModel.hasAnswered)
              AppElevatedButton(
                text: 'Submit',
                onPressed: () {
                  if (viewModel.qaAnswer?.isNotEmpty ?? false) {
                    viewModel.checkAnswer(viewModel.qaAnswer);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter an answer')),
                    );
                  }
                },
              ),
            if (viewModel.hasAnswered)
              Text(
                viewModel.qaAnswer == quiz.correctAnswer
                    ? 'Correct!'
                    : 'Incorrect. Correct answer: ${quiz.correctAnswer}',
                style: AppStyles.STYLE_14.copyWith(
                  color: viewModel.qaAnswer == quiz.correctAnswer
                      ? AppColor.green
                      : AppColor.red,
                ),
              ),
          ],
        );
      case null:
        throw UnimplementedError();
    }
  }

  Widget _buildSingleChoiceOption(int index, QuizVM viewModel) {
    final quiz = viewModel.quizs[viewModel.currentIndex];
    bool isCorrect = index == quiz.correctOptionIndex;
    bool isSelected = viewModel.selectedOption == index;
    Color bgColor = viewModel.hasAnswered
        ? (isCorrect
            ? AppColor.green
            : isSelected
                ? AppColor.red
                : AppColor.white)
        : AppColor.white;
    Color colorText = viewModel.hasAnswered && (isCorrect || isSelected)
        ? AppColor.bgColor
        : AppColor.textColor;

    return InkWell(
      onTap: viewModel.hasAnswered ? null : () => viewModel.checkAnswer(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: AppShadow.boxShadowContainer,
        ),
        child: Text(
          quiz.options?[index] ?? '',
          style: AppStyles.STYLE_14.copyWith(color: colorText),
        ),
      ),
    );
  }

  Widget _buildMultipleChoiceOption(int index, QuizVM viewModel) {
    final quiz = viewModel.quizs[viewModel.currentIndex];
    bool isCorrect = quiz.correctOptionIndices?.contains(index) ?? false;
    bool isSelected = viewModel.selectedOptions.contains(index);
    Color bgColor = viewModel.hasAnswered
        ? (isCorrect
            ? AppColor.green
            : isSelected
                ? AppColor.red
                : AppColor.white)
        : AppColor.white;
    Color colorText = viewModel.hasAnswered && (isCorrect || isSelected)
        ? AppColor.bgColor
        : AppColor.textColor;

    return InkWell(
      onTap: viewModel.hasAnswered
          ? null
          : () {
              viewModel.updateMultipleChoiceSelection(
                  index, !viewModel.selectedOptions.contains(index));
            },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: AppShadow.boxShadowContainer,
        ),
        child: Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: viewModel.hasAnswered
                  ? null
                  : (value) {
                      viewModel.updateMultipleChoiceSelection(
                          index, value ?? false);
                    },
            ),
            Expanded(
              child: Text(
                quiz.options?[index] ?? '',
                style: AppStyles.STYLE_14.copyWith(color: colorText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
