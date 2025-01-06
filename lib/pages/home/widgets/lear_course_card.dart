import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';

class LearCourseCard extends StatelessWidget {
  const LearCourseCard(this.course, {super.key, this.onPressed});

  final CourseModel course;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 180.0,
        height: 188.0,
        margin: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
        decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: AppShadow.boxShadowContainer),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: CachedNetworkImage(
                imageUrl: course.imageCourse ?? "",
                fit: BoxFit.cover,
                height: 83.0,
                width: 180.0,
                errorWidget: (context, __, ___) {
                  return Container(
                    height: 83.0,
                    decoration: const BoxDecoration(
                      color: AppColor.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: const Icon(Icons.error_rounded, color: AppColor.white),
                  );
                },
                placeholder: (context, __) {
                  return const SizedBox.square(
                    dimension: 20.0,
                    child: Center(
                      child: SizedBox.square(
                        dimension: 26.0,
                        child: CircularProgressIndicator(
                          color: AppColor.white,
                          strokeWidth: 2.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Content padding
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.category ?? "",
                    style: AppStyles.STYLE_12.copyWith(color: AppColor.textColor,fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    course.name ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.STYLE_14.copyWith(
                        color: AppColor.textColor),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2.0),
                          child: const LinearProgressIndicator(
                            // value: (completed ?? 0) / (total ?? 0),
                            value: 5,
                            backgroundColor: AppColor.grey,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColor.blue,
                            ),
                            minHeight: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '5/10',
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
      ),
    );
  }
}
