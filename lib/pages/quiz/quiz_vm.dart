import 'package:chat_app/models/quiz_model.dart';
import 'package:chat_app/pages/result_page/result_page.dart';
import 'package:chat_app/services/remote/quiz_services.dart';
import 'package:chat_app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class QuizVM extends BaseViewModel {
  QuizVM({required this.couseId});
  final String couseId;

  //===========================/
  final QuizServices _quizServices = QuizServices();
  List<QuizModel> quizs = [];
  int currentIndex = 0;
  int? selectedOption;
  List<int> selectedOptions = [];
  String? qaAnswer;
  bool hasAnswered = false;
  bool isLoading = false;
  int score = 0;

  Future<void> onInit() async {
    isLoading = true;
    rebuildUi();
    quizs = await _quizServices.getQuizs(couseId) ?? [];
    isLoading = false;
    rebuildUi();
  }

  void checkAnswer(dynamic answer) {
    hasAnswered = true;
    switch (quizs[currentIndex].type) {
      case QuizType.singleChoice:
        selectedOption = answer as int;
        if (selectedOption == quizs[currentIndex].correctOptionIndex) {
          score++;
        }
        break;
      case QuizType.multipleChoice:
        selectedOptions = List<int>.from(answer as List);
        List<int> correctAnswers =
            quizs[currentIndex].correctOptionIndices ?? [];
        if (selectedOptions.length == correctAnswers.length &&
            selectedOptions.every((index) => correctAnswers.contains(index))) {
          score++;
        }
        break;
      case QuizType.qa:
        qaAnswer = answer as String;
        if (qaAnswer?.trim().toLowerCase() ==
            quizs[currentIndex].correctAnswer?.trim().toLowerCase()) {
          score++;
        }
        break;
      case null:
        throw UnimplementedError();
    }
    rebuildUi();
  }

  void nextQuestion(BuildContext context) {
    if (currentIndex < quizs.length - 1) {
      currentIndex++;
      selectedOption = null;
      selectedOptions.clear();
      qaAnswer = null;
      hasAnswered = false;
      notifyListeners();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            score: score,
            totalQuestion: quizs.length,
          ),
        ),
      );
    }
  }

  void updateMultipleChoiceSelection(int index, bool isSelected) {
    if (isSelected) {
      selectedOptions.add(index);
    } else {
      selectedOptions.remove(index);
    }
    notifyListeners();
  }
}
