import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/pages/quiz/quiz_vm.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class QuizPage extends StackedView<QuizVM> {
  const QuizPage({super.key, required this.couseId});
  final String couseId;

  @override
  void onViewModelReady(QuizVM viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.onInit();
  }

  @override
  QuizVM viewModelBuilder(BuildContext context) => QuizVM(couseId: couseId);

  @override
  Widget builder(BuildContext context, QuizVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: const AppTabBarBlue(title: 'Quiz'),
      body: viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: AppColor.blue,
            ))
          : viewModel.quizs.isEmpty
              ? Center(
                  child: Text(
                  "No Quiz yey!",
                  style: AppStyles.STYLE_20.copyWith(color: AppColor.blue),
                ))
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: (viewModel.currentIndex + 1) / viewModel.quizs.length,
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
                          viewModel.quizs[viewModel.currentIndex].question ?? '',
                          textAlign: TextAlign.center,
                          style:
                              AppStyles.STYLE_14.copyWith(color: AppColor.blue),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: (viewModel.quizs[viewModel.currentIndex].options ?? []).length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 15.0),
                          itemBuilder: (context, index) {
                            return _buildOption(index,viewModel);
                          },
                        ),
                      ),
                      if (viewModel.hasAnswered)
                        AppElevatedButton(
                          onPressed: () => viewModel.nextQuestion(context),
                          text: viewModel.currentIndex == viewModel.quizs.length - 1
                              ? 'Finish'
                              : 'Next',
                        ),
                      const SizedBox(height: 200.0),
                    ],
                  ),
                ),
    );
  }

  Widget _buildOption(int index, QuizVM viewModel) {
    bool isCorrect = (viewModel.quizs[viewModel.currentIndex].correctOption ?? '').toLowerCase() ==
        viewModel.quizs[viewModel.currentIndex].options?[index].toLowerCase();
    bool isSelected = viewModel.selectOtion == index;
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
          viewModel.quizs[viewModel.currentIndex].options?[index] ?? '',
          style: AppStyles.STYLE_14.copyWith(color: colorText),
        ),
      ),
    );
  }
}

