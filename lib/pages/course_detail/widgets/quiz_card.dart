import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({super.key, this.onTap});

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quiz',
                  style: AppStyles.STYLE_16_BOLD
                      .copyWith(color: AppColor.textColor),
                ),
                Text(
                  'Tap to do Quiz',
                  style: AppStyles.STYLE_14.copyWith(color: AppColor.textColor),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            AppImages.icArrowRightBig,
            height: 22.0,
            width: 22.0,
          )
        ],
      ),
    );
  }
}
