import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/mv_simmer.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';

class AppCourseCard extends StatelessWidget {
  const AppCourseCard(this.course, {super.key, this.onPressed});

  final CourseModel course;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.bgColor,
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: CachedNetworkImage(
                  imageUrl: course.imageCourse ?? "",
                  fit: BoxFit.cover,
                  width: 171.0,
                  height: 162.0,
                  errorWidget: (context, __, ___) => const AppSimmer(
                    width: 171.0,
                    height: 162.0,
                  ),
                  placeholder: (context, __) => const AppSimmer(
                    width: 171.0,
                    height: 162.0,
                  ),
                ),
              )),
          Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.STYLE_12.copyWith(
                        color: AppColor.textColor,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Review",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.STYLE_12.copyWith(
                            color: AppColor.textColor.withOpacity(0.7),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "100",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.STYLE_12.copyWith(
                            color: AppColor.textColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 30.0,
                      margin: const EdgeInsets.only(top: 10.0, bottom: 35.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColor.blue),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0))),
                      child: Text(
                        course.category ?? "",
                        style: AppStyles.STYLE_12.copyWith(
                          color: AppColor.blue,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: AppElevatedButton.outline(
                          text: 'View',
                        )),
                        Expanded(
                          child: AppElevatedButton.outline(
                            text: 'Edit',
                            onPressed: onPressed,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
