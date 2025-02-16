
import 'package:chat_app/components/app_date_picker.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class AppModal {
  AppModal._();


  static Future<DateTime?> showBottomModalPickTime(BuildContext context) async {
    DateTime selectedDay = DateTime.now();
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: AppColor.bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setStatus) {
          return FractionallySizedBox(
            heightFactor: 0.7,
            child: Padding(
              padding:const EdgeInsets.all(16.0).copyWith(bottom: 12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Xóa',
                        style: AppStyles.STYLE_14.copyWith(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy HH:mm').format(selectedDay),
                        style: AppStyles.STYLE_14.copyWith(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(false),
                        child: SvgPicture.asset(
                          AppImages.iconClosed,
                          width: 24.0,
                          height: 24.0,
                        ),
                      )
                    ],
                  ),
                  const Divider(color: AppColor.blue),
                  Row(
                    children: [
                      Expanded(
                        child: AppDatePicker(
                          type: DatePickerType.date,
                          onDateSelected: (value) {
                            selectedDay = DateTime.now().add(
                              Duration(days: value - 128),
                            );
                            setStatus(() {});
                          },
                        ),
                      ),
                      Expanded(
                        child: AppDatePicker(
                          type: DatePickerType.hour,
                          onDateSelected: (value) {
                            selectedDay = DateTime(
                              selectedDay.year,
                              selectedDay.month,
                              selectedDay.day,
                              value,
                              selectedDay.minute,
                            );
                            setStatus(() {});
                          },
                        ),
                      ),
                      Expanded(
                        child: AppDatePicker(
                          type: DatePickerType.minute,
                          onDateSelected: (value) {
                            selectedDay = DateTime(
                              selectedDay.year,
                              selectedDay.month,
                              selectedDay.day,
                              selectedDay.hour,
                              value,
                            );
                            setStatus(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: AppElevatedButton(
                            color: AppColor.bgColor,
                            textColor: AppColor.orange,
                            text: 'Thoát',
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: AppElevatedButton(
                            text: 'Xác nhận',
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    ).then((value) {
      if (value ?? false) {
        return selectedDay;
      }
      return null;
    });
  }

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
