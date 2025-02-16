import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppDivider {

  AppDivider._();

  static dividerWidget() {
    return const Divider(
      color: AppColor.blue,
      height: 1.0,
    );
  }
}
