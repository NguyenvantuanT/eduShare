
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppModal {
  AppModal._();

  static Future<void> todoModal(
    BuildContext context, {
    Function()? onDelete,
    Function()? onComplete,
  }) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColor.bgColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppElevatedButton(
                          text: "Delete",
                          onPressed: () {
                            onDelete?.call();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: AppElevatedButton(
                          text: "Complete",
                          onPressed: () {
                            onComplete?.call();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AppElevatedButton.outline(
                    text: "Cancle",
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              ],
            ),
          );
        });
  }
}
