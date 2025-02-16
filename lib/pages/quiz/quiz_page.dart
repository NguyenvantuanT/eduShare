import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/models/quiz_model.dart';
import 'package:chat_app/pages/result_page/result_page.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/remote/quiz_services.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.couseId});

  final String couseId;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<QuizModel> quizs = [];
  QuizServices quizServices = QuizServices();
  bool isLoading = false;
  int currentIndex = 0;
  int? selectOtion;
  int score = 0;
  bool hasAnswered = false;

  @override
  void initState() {
    super.initState();
    getQuizs();
  }

  void getQuizs() {
    setState(() => isLoading = true);
    quizServices.getQuizs(widget.couseId).then((value) {
      quizs = value;
      setState(() => isLoading = false);
    });
  }

  void checkAnswer(int index) {
    bool isCorrect = (quizs[currentIndex].correctOption ?? '').toLowerCase() ==
        quizs[currentIndex].options?[index].toLowerCase();
    setState(() {
      hasAnswered = true;
      selectOtion = index;
      if (isCorrect) {
        score++;
        print(score);
      }
    });
  }

  void nextQuestion() {
    if (currentIndex < quizs.length - 1) {
      setState(() {
        currentIndex++;
        hasAnswered = false;
        selectOtion = null;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: const AppTabBarBlue(title: 'Quiz'),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: AppColor.blue,
            ))
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: (currentIndex + 1) / quizs.length,
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
                      quizs[currentIndex].question ?? '',
                      textAlign: TextAlign.center,
                      style: AppStyles.STYLE_14.copyWith(color: AppColor.blue),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: (quizs[currentIndex].options ?? []).length,
                      separatorBuilder: (_, __) => const SizedBox(height: 15.0),
                      itemBuilder: (context, index) {
                        return _buildOption(index);
                      },
                    ),
                  ),
                  if (hasAnswered)
                    AppElevatedButton(
                      onPressed: nextQuestion,
                      text:
                          currentIndex == quizs.length - 1 ? 'Finish' : 'Next',
                    ),
                  const SizedBox(height: 200.0),
                ],
              ),
            ),
    );
  }

  Widget _buildOption(int index) {
    bool isCorrect = (quizs[currentIndex].correctOption ?? '').toLowerCase() ==
        quizs[currentIndex].options?[index].toLowerCase();
    bool isSelected = selectOtion == index;
    Color bgColor = hasAnswered
        ? (isCorrect
            ? AppColor.green
            : isSelected
                ? AppColor.red
                : AppColor.white)
        : AppColor.white;
    Color colorText = hasAnswered && (isCorrect || isSelected)
        ? AppColor.bgColor
        : AppColor.textColor;
    return InkWell(
      onTap: hasAnswered ? null : () => checkAnswer(index),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: AppShadow.boxShadowContainer,
        ),
        child: Text(
          quizs[currentIndex].options?[index] ?? '',
          style: AppStyles.STYLE_14.copyWith(color: colorText),
        ),
      ),
    );
  }
}
