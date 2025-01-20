import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/components/mv_simmer.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';

class FavoriteItem extends StatelessWidget {
  const FavoriteItem(this.course, {super.key, this.onTap, this.onFavorite});

  final CourseModel course;
  final Function()? onTap;
  final Function()? onFavorite;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.name ?? "",
                      style: AppStyles.STYLE_12.copyWith(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4.0),
                  Text('${course.createBy} | ${course.category}',
                      style: AppStyles.STYLE_10),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: onFavorite,
                        behavior: HitTestBehavior.translucent,
                        child: const Padding(
                          padding: EdgeInsets.all(4.6),
                          child: Icon(
                            Icons.favorite,
                            size: 20.0,
                            color: AppColor.blue,
                          ),
                        ),
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
