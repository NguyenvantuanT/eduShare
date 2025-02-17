import 'package:chat_app/models/quiz_model.dart';
import 'package:chat_app/pages/result_page/result_page.dart';
import 'package:chat_app/services/remote/quiz_services.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class QuizVM extends BaseViewModel {
  QuizVM({required this.couseId});
  final String couseId;

  //===========================/
  List<QuizModel> quizs = [];
  QuizServices quizServices = QuizServices();
  bool isLoading = false;
  int currentIndex = 0;
  int? selectOtion;
  int score = 0;
  bool hasAnswered = false;

  void onInit() {
    getQuizs();
  }

  void getQuizs() {
    isLoading = true;
    rebuildUi();
    quizServices.getQuizs(couseId).then((value) {
      quizs = value ?? [];
      isLoading = false;
      rebuildUi();
    });
  }

  void checkAnswer(int index) {
    bool isCorrect = (quizs[currentIndex].correctOption ?? '').toLowerCase() ==
        quizs[currentIndex].options?[index].toLowerCase();
    hasAnswered = true;
    selectOtion = index;
    if (isCorrect) {
      score++;
    }
    rebuildUi();
  }

  void nextQuestion(BuildContext context) {
    if (currentIndex < quizs.length - 1) {
      currentIndex++;
      hasAnswered = false;
      selectOtion = null;
      rebuildUi();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            score: score,
            totalQuestion: quizs.length,
          ),
        ),
      );
    }
  }
}
