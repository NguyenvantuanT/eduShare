import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CourseButton extends StatelessWidget {
  const CourseButton({
    super.key,
    this.onTap,
    required this.text,
    this.isLearning = true,
    this.icon,
  });

  final Function()? onTap;
  final String text;
  final bool isLearning;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30.0,
        margin:
            const EdgeInsets.symmetric(vertical: 15.0).copyWith(right: 10.0),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: AppColor.blue.withOpacity(0.25),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: AppStyles.STYLE_14.copyWith(
                  color: isLearning ? AppColor.blue : AppColor.greyText),
            ),
            if (icon != null) ...[
              const SizedBox(width: 5.0),
              SvgPicture.asset(
                icon!,
                color: AppColor.blue,
                height: 22.0,
                width: 22.0,
              )
            ]
          ],
        ),
      ),
    );
  }
}
