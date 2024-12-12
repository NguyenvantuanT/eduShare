import 'dart:async';

import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
      if (SharedPrefs.isLogin) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: Center(
        child: Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.grey.shade400,
          child: const Text(
            "V T",
            style: TextStyle(
                color: AppColor.grey,
                fontSize: 45.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
