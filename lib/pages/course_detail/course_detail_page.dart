import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class CourseDetailPage extends StatefulWidget {
  const CourseDetailPage(this.course, {super.key});

  final CourseModel course;

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: ListView(
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: widget.course.imageCourse ?? "",
                fit: BoxFit.cover,
                height: 200.0,
                width: double.maxFinite,
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
                    child:
                        const Icon(Icons.error_rounded, color: AppColor.white),
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
              Positioned(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.translucent,
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      radius: 16.0,
                      backgroundColor: AppColor.bgColor,
                      child: Padding(
                        padding: EdgeInsets.only(right: 3.0),
                        child: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          size: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50.0,
                      decoration: const BoxDecoration(
                          color: AppColor.bgColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          )),
                    ),
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.course.name ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.STYLE_18
                              .copyWith(color: AppColor.textColor),
                        ),
                        Text(
                          widget.course.createBy ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.STYLE_14
                              .copyWith(color: AppColor.greyText),
                        ),
                      ],
                    ),
                    Container(
                      height: 30.0,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: AppColor.blue.withOpacity(0.25),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Text(
                        widget.course.category ?? "",
                        style:
                            AppStyles.STYLE_14.copyWith(color: AppColor.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                Text(
                  'Description',
                  style: AppStyles.STYLE_16_BOLD
                      .copyWith(color: AppColor.textColor),
                ),
                const SizedBox(height: 15.0),
                ReadMoreText(
                  widget.course.description ?? "",
                  trimLines: 3,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: " Read more",
                  trimExpandedText: " End text",
                  style: AppStyles.STYLE_14.copyWith(color: AppColor.textColor),
                  lessStyle: AppStyles.STYLE_14.copyWith(color: AppColor.blue),
                  moreStyle: AppStyles.STYLE_14.copyWith(color: AppColor.blue),
                ),
                const SizedBox(height: 30.0),
                Text(
                  'Lessons',
                  style: AppStyles.STYLE_16_BOLD
                      .copyWith(color: AppColor.textColor),
                ),
                const SizedBox(height: 15.0),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (widget.course.lessons ?? []).length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: AppColor.greyText),
                  itemBuilder: (context, idx) {
                    final lesson = widget.course.lessons![idx];
                    return Column(
                      children: [
                        Text(
                          'Lesson: ${idx + 1}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.STYLE_14
                              .copyWith(color: AppColor.textColor),
                        ),
                        Text(
                          lesson.name ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.STYLE_14
                              .copyWith(color: AppColor.textColor),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
