import 'dart:async';

import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/pages/onBoarding/on_boarding_page.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  void _checkStatus() {
    Timer(const Duration(milliseconds: 2600), () {
      if (SharedPrefs.isAccessed) {
        if (SharedPrefs.isLogin) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainPage()),
              (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false);
        }
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const OnBoardingPage()),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: Center(child: SvgPicture.asset(AppImages.imageLogo)),
    );
  }
}
