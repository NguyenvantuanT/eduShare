import 'dart:convert';

import 'package:chat_app/models/quiz_model.dart';
import 'package:chat_app/models/trivia_mode.dart';
import 'package:chat_app/services/remote/quiz_services.dart';
import 'package:chat_app/services/remote/trivia_services.dart';
import 'package:chat_app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CreateQuizVM extends BaseViewModel {
  CreateQuizVM({
    required this.courseId,
    this.onUpdate,
    this.quiz,
  });

  final String courseId;
  final Function()? onUpdate;
  final QuizModel? quiz;

  final questionController = TextEditingController();
  QuizType selectedType = QuizType.singleChoice;
  DifficultyLevel selectedDifficulty = DifficultyLevel.normal;
  final formKey = GlobalKey<FormState>();
  QuizServices quizServices = QuizServices();
  final optionControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  int? correctOptionIndex;
  List<int> correctOptionIndices = [];
  final correctAnswerController = TextEditingController();
  TriviaServices triviaServices = TriviaServices();
  bool isLoading = false;
  List<TriviaModel> trivis = [];

  @override
  void dispose() {
    questionController.dispose();
    correctAnswerController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void initializeQuizData() async {
    getTrivias();
    getQuiz();
  }

  void getTrivias() {
    triviaServices.getTrivias().then((response) {
      final data = jsonDecode(response.body);
      List<Map<String, dynamic>> maps = (data['results'] ?? [])
          .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>;
      trivis = maps.map((e) => TriviaModel.fromJson(e)).toList();
    });
  }

  void getQuiz() {
    if (quiz != null) {
      questionController.text = quiz?.question ?? '';
      selectedType = quiz?.type ?? QuizType.singleChoice;
      if (quiz!.options != null) {
        for (int i = 0; i < quiz!.options!.length && i < 4; i++) {
          optionControllers[i].text = quiz?.options?[i] ?? '';
        }
      }
      correctOptionIndex = quiz?.correctOptionIndex;
      correctOptionIndices = quiz?.correctOptionIndices ?? [];
      correctAnswerController.text = quiz?.correctAnswer ?? '';
    }
  }

  void selectSuggestion(TriviaModel trivia) {
  questionController.text = trivia.question ?? '';
  if (selectedType == QuizType.qa) {
    correctAnswerController.text = trivia.correctAnswer ?? '';
  } else {
    final allOptions = [...trivia.incorrectAnswers ?? [], trivia.correctAnswer]..shuffle();
    for (int i = 0; i < optionControllers.length; i++) {
      optionControllers[i].text = (i < allOptions.length ? allOptions[i] : '') ?? '';
    }
    correctOptionIndex = allOptions.indexOf(trivia.correctAnswer);
  }
  rebuildUi();
}

  void choiceDifficulty(DifficultyLevel? difficulty) {
    if (difficulty != null && difficulty != selectedDifficulty) {
      selectedDifficulty = difficulty;
      rebuildUi();
    }
  }

  void createQuiz(BuildContext context) async {
    final options = optionControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    QuizModel quizModel = QuizModel(
      quizId: quiz?.quizId,
      question: questionController.text.trim(),
      correctOptionIndex: correctOptionIndex,
      options: options,
      type: selectedType,
      difficulty: selectedDifficulty,
      correctOptionIndices: correctOptionIndices,
      correctAnswer: correctAnswerController.text,
    );

    try {
      isLoading = true;
      rebuildUi();

      if (quiz == null) {
        await quizServices.createQuiz(courseId, quizModel);
      } else {
        await quizServices.updateQuiz(courseId, quizModel);
      }
      onUpdate?.call();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        return Navigator.of(context).pop();
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      rebuildUi();
    }
  }

  void choiceQuizType(QuizType? type) {
    if (type != null && type != selectedType) {
      selectedType = type;
      correctOptionIndex = null;
      correctOptionIndices.clear();
      correctAnswerController.clear();
      for (var controller in optionControllers) {
        controller.clear();
      }
      rebuildUi();
    }
  }
}
