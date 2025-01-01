import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InformationCard extends StatelessWidget {
  InformationCard({
    super.key,
    this.icon,
    this.title,
    this.infor,
    Widget? type,
    this.onPressed,
  }) : type = type ??
            Text(
              'Edit',
              style: AppStyles.STYLE_12.copyWith(
                color: AppColor.textColor,
              ),
            );

  final String? icon;
  final String? title;
  final String? infor;
  final Widget? type;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: AppColor.white,
                boxShadow: AppShadow.boxShadowIcon),
            child: SvgPicture.asset(icon ?? ''),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? "",
                  style: AppStyles.STYLE_14.copyWith(
                    color: AppColor.textColor,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  infor ?? '',
                  style: AppStyles.STYLE_12.copyWith(
                    color: AppColor.greyText,
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 10.0),
              child: type)
        ],
      ),
    );
  }
}
