import 'package:chat_app/components/app_divider.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/enum.dart';
import 'package:chat_app/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class AppDatePicker extends StatelessWidget {
  const AppDatePicker({
    super.key,
    required this.type,
    this.onDateSelected,
  });

  final DatePickerType type;
  final Function(int)? onDateSelected;

  @override
  Widget build(BuildContext context) {
    DateTime selectedDay = DateTime.now();
    final initialIndex = type == DatePickerType.date
        ? 128
        : type == DatePickerType.hour
            ? selectedDay.hour
            : selectedDay.minute;

    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: initialIndex);

    return Column(
      children: [
        Stack(
          fit: StackFit.loose,
          children: [
            Positioned(
              child: SizedBox(
                height: 200.0,
                child: CupertinoPicker(
                  selectionOverlay: Container(),
                  scrollController: scrollController,
                  backgroundColor: Colors.white,
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    onDateSelected?.call(index);
                  },
                  children: List<Widget>.generate(
                    type == DatePickerType.date
                        ? 365
                        : type == DatePickerType.hour
                            ? 24
                            : 60,
                    (index) {
                      final date =
                          DateTime.now().add(Duration(days: index - 128));
                      final isDay = date.isToday;
                      return Center(
                        child: Text(
                          type == DatePickerType.date
                              ? isDay
                                  ? "${DateFormat('EEE ').format(date)} Today"
                                  : DateFormat('EEE MMM dd').format(date)
                              : index.toString().padLeft(2, '0'),
                          style: AppStyles.STYLE_14.copyWith(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 200 / 2 - 20,
                ),
                child: AppDivider.dividerWidget(),
              ),
            ),
            Positioned(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 200 / 2 + 20,
                ),
                child: AppDivider.dividerWidget(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
