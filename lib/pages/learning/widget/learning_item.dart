import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/components/mv_simmer.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';

class LearningItem extends StatelessWidget {
  const LearningItem(this.course, {super.key, this.onTap});
  final CourseModel course;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: AppShadow.boxShadowContainer),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: course.imageCourse ?? "",
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                  errorWidget: (context, __, ___) => const AppSimmer(
                    height: 100.0,
                    width: 100.0,
                  ),
                  placeholder: (_, __) => const AppSimmer(
                    height: 100.0,
                    width: 100.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 30.0,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 10.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: AppColor.blue.withOpacity(0.25),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: Text(
                          course.category ?? "",
                          style:
                              AppStyles.STYLE_14.copyWith(color: AppColor.blue),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    course.name ?? "",
                    style: AppStyles.STYLE_12.copyWith(
                        color: AppColor.textColor, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${course.lessons?.length} Lessons",
                    style: AppStyles.STYLE_12.copyWith(
                      color: AppColor.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
