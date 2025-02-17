import 'package:chat_app/models/onboarding_model.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class OnBoardingVm extends BaseViewModel{
  final pageController = PageController();
  int currentIndex = 0;

  void onInit() {
    SharedPrefs.isAccessed = true;
  }

  void changePage(int pageViewIndex) {
    currentIndex = pageViewIndex;
    rebuildUi();
  }

  void onPressed(BuildContext context) {
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
  }
}