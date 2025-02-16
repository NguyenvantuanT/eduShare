import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/models/quiz_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/remote/quiz_services.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({super.key, required this.courseId, this.onUpdate});

  final String courseId;
  final Function()? onUpdate;

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
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

    print(quizModel.toJson());

    quizServices.createQuiz(widget.courseId, quizModel).then((value) {
      widget.onUpdate?.call();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        return Navigator.of(context).pop();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: const AppTabBarBlue(title: 'Create Quiz'),
      body: Form(
        key: formKey,
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
              controller: questionController,
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
              controller: optionOneController,
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
              controller: optionTwoController,
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
              controller: optionThreeController,
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
              controller: optionFourController,
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
              controller: optionCorrectController,
              labelText: "Correct...",
              textInputAction: TextInputAction.next,
              validator: Validator.required,
            ),
            const SizedBox(height: 20.0),
            FractionallySizedBox(
                widthFactor: 0.5,
                child: AppElevatedButton(
                  text: "Create Quiz",
                  onPressed: () => createQuiz(context),
                ))
          ],
        ),
      ),
    );
  }
}
