import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/models/onboarding_model.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final pageController = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    SharedPrefs.isAccessed = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(
          top: MediaQuery.of(context).padding.top + 50.0,
          bottom: 50.0,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 240.0,
              child: PageView(
                controller: pageController,
                onPageChanged: (pageViewIndex) {
                  currentIndex = pageViewIndex;
                  setState(() {});
                },
                children: List.generate(
                  onboardings.length,
                  (idx) => SvgPicture.asset(onboardings[idx].imagePath ?? "",
                      fit: BoxFit.fitHeight),
                ),
              ),
            ),
            Container(
              height: 80.0,
              margin: const EdgeInsets.only(top: 20.0,bottom: 20.0),
              child: Text(
                onboardings[currentIndex].text ?? "",
                textAlign: TextAlign.center,
                style: AppStyles.STYLE_14,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(onboardings.length, (idx) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.6),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: idx == currentIndex ? 30.0 : 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                        color: idx == currentIndex ? AppColor.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                );
              }),
            ),
            const Spacer(),
            AppElevatedButton(
              text: currentIndex == onboardings.length - 1 ? 'Start' : 'Next',
              onPressed: () {
                if (currentIndex < onboardings.length - 1) {
                  currentIndex++;
                  pageController.jumpToPage(currentIndex);
                } else {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
