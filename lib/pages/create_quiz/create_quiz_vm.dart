import 'package:chat_app/models/quiz_model.dart';
import 'package:chat_app/services/remote/quiz_services.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CreateQuizVM extends BaseViewModel{
  CreateQuizVM({required this.courseId, this.onUpdate});
  final String courseId;
  final Function()? onUpdate;


  final questionController = TextEditingController();
  final optionOneController = TextEditingController();
  final optionTwoController = TextEditingController();
  final optionThreeController = TextEditingController();
  final optionFourController = TextEditingController();
  final optionCorrectController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  QuizServices quizServices = QuizServices();

  void createQuiz(BuildContext context) {
    List<String>? options = [
      optionOneController.text.trim(),
      optionTwoController.text.trim(),
      optionThreeController.text.trim(),
      optionFourController.text.trim(),
    ];
    QuizModel quizModel = QuizModel(
      question: questionController.text.trim(),
      correctOption: optionCorrectController.text.trim(),
      options: options,
    );
    quizServices.createQuiz(courseId, quizModel).then((value) {
      onUpdate?.call();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        return Navigator.of(context).pop();
      });
    });
  }
}