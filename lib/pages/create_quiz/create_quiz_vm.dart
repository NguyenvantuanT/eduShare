import 'package:chat_app/models/quiz_model.dart';
import 'package:chat_app/services/remote/quiz_services.dart';
import 'package:chat_app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CreateQuizVM extends BaseViewModel {
  CreateQuizVM({required this.courseId, this.onUpdate});
  final String courseId;
  final Function()? onUpdate;

  final questionController = TextEditingController();
  QuizType selectedType = QuizType.singleChoice;
  final formKey = GlobalKey<FormState>();
  QuizServices quizServices = QuizServices();
  final optionControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  int? correctOptionIndex; // Single choice
  List<int> correctOptionIndices = []; // Multiple choice
  final correctAnswerController = TextEditingController();

  @override
  void dispose() {
    questionController.dispose();
    correctAnswerController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void createQuiz(BuildContext context) {
    final options = optionControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    QuizModel quizModel = QuizModel(
      question: questionController.text.trim(),
      correctOptionIndex: correctOptionIndex,
      options: options,
      type: selectedType,
      quizId: courseId,
      correctOptionIndices: correctOptionIndices,
      correctAnswer: correctAnswerController.text,
    );

    quizServices.createQuiz(courseId, quizModel).then((value) {
      onUpdate?.call();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        return Navigator.of(context).pop();
      });
    });
  }

  void choiceQuizType(QuizType? type) {
    selectedType = type ?? QuizType.singleChoice;
    rebuildUi();
  }
}
