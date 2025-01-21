import 'package:chat_app/components/app_avatar.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:flutter/material.dart';

class AppTabBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTabBar({
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
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
          top: MediaQuery.of(context).padding.top + 6.0, bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hi, ${SharedPrefs.user?.name}',
                style: AppStyles.STYLE_18_BOLD.copyWith(
                  color: AppColor.textColor,
                ),
              ),
              Text(
                title,
                style: AppStyles.STYLE_14.copyWith(color: AppColor.greyText),
              ),
            ],
          ),
          GestureDetector(
            onTap: rightPressed,
            child: AppAvatar(avatar: avatar, isActive: true),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(86.0);
}
