import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/mv_simmer.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';

class CourseSearchItem extends StatelessWidget {
  const CourseSearchItem(this.course, {super.key, this.onTap});

  final CourseModel course;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: course.imageCourse ?? "",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                    errorWidget: (context, __, ___) => const AppSimmer(
                      height: 50.0,
                      width: 50.0,
                    ),
                    placeholder: (_, __) => const AppSimmer(
                      height: 50.0,
                      width: 50.0,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name ?? "",
                        style: AppStyles.STYLE_14
                            .copyWith(color: AppColor.textColor),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        course.createBy ?? "",
                        style: AppStyles.STYLE_12
                            .copyWith(color: AppColor.greyText),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
