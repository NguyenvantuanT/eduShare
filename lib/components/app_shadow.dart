import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppShadow {
  AppShadow._();

  static const boxShadowLogin = [
    BoxShadow(
      color: AppColor.grey,
      blurRadius: 6.0,
      offset: Offset(3.0, 0),
    ),
    BoxShadow(
      color: AppColor.grey,
      blurRadius: 6.0,
      offset: Offset(3.0, 0),
    ),
  ];

  static const boxShadowContainer = [
    BoxShadow(
      color: AppColor.grey,
      spreadRadius: 1.0,
      blurRadius: 4.0,
      offset: Offset(0.0, 2.0),
    ),
  ];
}
