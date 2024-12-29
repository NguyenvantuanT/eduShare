import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.lessonCount,
    required this.hours,
    required this.minutes,
  });
  final String title;
  final String imageUrl;
  final int lessonCount;
  final int hours;
  final int minutes;
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
              borderRadius: BorderRadius.all(Radius.circular(12.0))
            ),
            child: Center(
              child: Image.network(
                imageUrl,
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
                  title,
                  style: AppStyles.STYLE_12.copyWith(
                      color: AppColor.textColor, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      '$lessonCount Lessons',
                      style: AppStyles.STYLE_12.copyWith(color: AppColor.greyText),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${hours}h ${minutes}m',
                      style: AppStyles.STYLE_12.copyWith(color: AppColor.greyText),
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
