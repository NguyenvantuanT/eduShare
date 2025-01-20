import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

class DelightToastShow {
  DelightToastShow._();

  static void showToast({
    BuildContext? context,
    String? text,
    Color? color = AppColor.shadow,
    IconData icon = Icons.info,
    Color? iconColor = AppColor.shadow,
  }) {
    DelightToastBar(
        autoDismiss: true,
        position: DelightSnackbarPosition.top,
        builder: (context) {
          return ToastCard(
            color:color,
            leading: Icon(icon, size: 28, color: iconColor,),
            title: Text(
              text ?? "",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          );
        }).show(context!);
  }
}
