import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppShadow {
  AppShadow._();

  static const boxShadow = [
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
}
