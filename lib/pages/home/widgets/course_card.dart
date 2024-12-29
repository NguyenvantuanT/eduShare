import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    this.subject,
    this.title,
    this.imageUrl,
    this.completed,
    this.total,
  });
  final String? subject;
  final String? title;
  final String? imageUrl;
  final int? completed;
  final int? total;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.0,
      margin: const EdgeInsets.only(top: 8.0 , bottom: 8.0 , right: 8.0),
      decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: AppShadow.boxShadowContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120.0,
            decoration: const BoxDecoration(
              color: AppColor.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Center(
              child: Image.network(
                imageUrl ?? '',
                height: 100,
                fit: BoxFit.cover,
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
                  subject ?? "",
                  style: AppStyles.STYLE_12.copyWith(color: AppColor.greyText),
                ),
                const SizedBox(height: 4.0),
                Text(
                  title ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.STYLE_12.copyWith(
                      color: AppColor.textColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2.0),
                        child: LinearProgressIndicator(
                          value: (completed ?? 0) / (total ?? 0),
                          backgroundColor: AppColor.grey,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColor.blue,
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$completed/$total',
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
