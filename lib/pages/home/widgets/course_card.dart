import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/mv_simmer.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard(this.course, {super.key, this.onPressed, this.idx = 0});
  final CourseModel course;
  final int idx;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 140.0,
            decoration: const BoxDecoration(
                color: AppColor.blue,
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              child: CachedNetworkImage(
                imageUrl: course.imageCourse ?? "",
                fit: BoxFit.cover,
                height: 83.0,
                errorWidget: (context, __, ___) => const AppSimmer(
                  height: 83.0,
                ),
                placeholder: (context, __) => const AppSimmer(
                  height: 83.0,
                ),
              ),
            ),
          ),
          // Content padding
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
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
                    Text("${course.rating}"),
                    const SizedBox(width: 2.0),
                    const Icon(
                      Icons.star,
                      color: AppColor.orange,
                      size: 20.0,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${12}h',
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
