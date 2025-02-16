import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({
    super.key,
    required this.score,
    required this.totalQuestion,
  });

  final int score;
  final int totalQuestion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: const AppTabBarBlue(title: "Your Result"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Lottie.network(
                    'https://lottie.host/baba8989-bf15-4dfe-8cdd-3b637d1bc58a/gWn4keqlvz.json',
                    height: 200,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 10.0,
                    child: Lottie.network(
                      'https://lottie.host/045c9565-ce99-415c-a7a4-8a6af5611547/Wc1BGbM3xY.json',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50.0),
              Text(
                "Quiz Completed!",
                style: AppStyles.STYLE_20_BOLD.copyWith(color: AppColor.blue),
              ),
              const SizedBox(height: 20.0),
              Text(
                "Your score $score out of $totalQuestion",
                style: AppStyles.STYLE_24,
              ),
              const SizedBox(height: 20.0),
              Text(
                "${(score / totalQuestion * 100).toStringAsFixed(2)}%",
                style: AppStyles.STYLE_20,
              ),
              const SizedBox(height: 30.0),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: AppElevatedButton(
                  text: 'Quit',
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const MainPage()),
                      (Route<dynamic> route) => false),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
