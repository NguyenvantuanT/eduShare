import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  const LessonCard(
    this.lesson, {
    super.key,
    this.onEdit,
    this.onDelete,
  });

  final LessonModel lesson;
  final Function()? onEdit;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.name ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.STYLE_14.copyWith(color: AppColor.textColor),
                ),
                const SizedBox(height: 4.0),
                Text(
                  lesson.description ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.STYLE_12.copyWith(color: AppColor.greyText),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.delete,
              color: AppColor.blue,
              size: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
