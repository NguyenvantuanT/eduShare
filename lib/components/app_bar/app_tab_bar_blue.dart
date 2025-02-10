import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';

class AppTabBarBlue extends StatelessWidget implements PreferredSizeWidget {
  const AppTabBarBlue({
    super.key,
    this.leftPressed,
    this.rightPressed,
    required this.title,
    this.avatar,
    this.color = AppColor.white,
  });

  final VoidCallback? leftPressed;
  final VoidCallback? rightPressed;
  final String title;
  final String? avatar;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.blue,
      padding: const EdgeInsets.symmetric(horizontal: 16.0)
          .copyWith(top: MediaQuery.of(context).padding.top + 15.0, bottom: 12.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 18.0,
              color: AppColor.bgColor,
            ),
          ),
          const SizedBox(width: 20.0),
          Text(
            title ,
            style: AppStyles.STYLE_18_BOLD.copyWith(color: AppColor.bgColor),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(86.0);
}
