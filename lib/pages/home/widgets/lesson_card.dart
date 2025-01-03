import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  const LessonCard(this.course, {super.key});
  final CourseModel course;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140.0,
            decoration: const BoxDecoration(
                color: AppColor.blue,
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            child: Center(
              child: Image.network(
                course.imageCourse ?? "",
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Content padding
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name ?? '',
                  style: AppStyles.STYLE_12.copyWith(
                      color: AppColor.textColor, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '${course.lessons?.length} Lessons',
                      style:
                          AppStyles.STYLE_12.copyWith(color: AppColor.greyText),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${12}h ${0.0}m',
                      style:
                          AppStyles.STYLE_12.copyWith(color: AppColor.greyText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
