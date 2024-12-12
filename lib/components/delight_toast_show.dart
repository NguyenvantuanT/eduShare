import 'package:chat_app/themes/app_colors.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

class DelightToastShow {
  DelightToastShow._();

  static void showToast({
    required BuildContext context,
    required String text,
    IconData icon = Icons.info,
  }) {
    DelightToastBar(
        autoDismiss: true,
        position: DelightSnackbarPosition.top,
        builder: (context) {
          return ToastCard(
            color: AppColor.shadow,
            leading: Icon(icon, size: 28),
            title: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          );
        }).show(context);
  }
}
