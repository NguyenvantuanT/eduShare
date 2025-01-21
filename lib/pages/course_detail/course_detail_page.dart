import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/components/mv_simmer.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/pages/lesson/lesson_page.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/course_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';

class CourseDetailPage extends StatefulWidget {
  const CourseDetailPage(this.docId, {super.key, this.onUpdate});

  final String docId;
  final VoidCallback? onUpdate;

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  CourseModel course = CourseModel();
  CourseServices courseServices = CourseServices();
  bool isFavorite = false;
  bool isLearning = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCourse();
  }

  void getCourse() {
    setState(() => isLoading = true);
    courseServices
        .getCourse(widget.docId)
        .then((value) {
          course = value;
          isFavorite =
              (course.favorites ?? []).any((e) => e == SharedPrefs.user?.email);
          isLearning =
              (course.learnings ?? []).any((e) => e == SharedPrefs.user?.email);
          setState(() {});
        })
        .catchError((onError) {})
        .whenComplete(() => setState(() => isLoading = true));
  }

  void toggleFavorite(BuildContext context) {
    setState(() => isFavorite = !isFavorite);
    courseServices.toggleFavorite(course, isFavorite).then((_) {
      if (!context.mounted) return;
      DelightToastShow.showToast(
          context: context,
          icon: Icons.favorite,
          iconColor: isFavorite ? AppColor.blue : null,
          text:
              'Course has been ${isFavorite ? 'add' : 'remote'} your favorites 😍',
          color: AppColor.bgColor);
      setState(() {});
    }).catchError((onError) {});
  }

  void toggleLearning(BuildContext context) {
  setState(() => isLearning = !isLearning);
  courseServices.toggleLearning(course, isLearning).then((_) {
    widget.onUpdate?.call();
    if (!context.mounted) return;
    DelightToastShow.showToast(
      context: context,
      icon: Icons.book,
      iconColor: isLearning ? AppColor.blue : null,
      text:
          'Course has been ${isLearning ? 'added to' : 'removed from'} your learning 😍',
      color: AppColor.bgColor,
    );
    setState(() {});
  }).catchError((onError) {
    print("Error: $onError");
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: ListView(
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: course.imageCourse ?? "",
                fit: BoxFit.cover,
                height: 200.0,
                width: double.maxFinite,
                errorWidget: (context, __, ___) =>
                    const AppSimmer(height: 200.0),
                placeholder: (_, __) => const AppSimmer(height: 200.0),
              ),
              Positioned(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, true),
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
                          course.name ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.STYLE_18
                              .copyWith(color: AppColor.textColor),
                        ),
                        Text(
                          course.createBy ?? "",
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
                        course.category ?? "",
                        style:
                            AppStyles.STYLE_14.copyWith(color: AppColor.blue),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => toggleLearning(context),
                      child: Container(
                        height: 30.0,
                        margin: const EdgeInsets.symmetric(vertical: 15.0)
                            .copyWith(right: 10.0),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: AppColor.blue.withOpacity(0.25),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: Text(
                          "Add to lear",
                          style: AppStyles.STYLE_14.copyWith(
                              color: isLearning
                                  ? AppColor.blue
                                  : AppColor.greyText),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => toggleFavorite(context),
                      child: isFavorite
                          ? const Icon(
                              Icons.favorite,
                              color: AppColor.blue,
                            )
                          : const Icon(
                              Icons.favorite_outline,
                              color: AppColor.greyText,
                            ),
                    ),
                  ],
                ),
                Text(
                  'Description',
                  style: AppStyles.STYLE_16_BOLD
                      .copyWith(color: AppColor.textColor),
                ),
                const SizedBox(height: 15.0),
                ReadMoreText(
                  course.description ?? "",
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
                  itemCount: (course.lessons ?? []).length,
                  separatorBuilder: (_, __) =>
                      Divider(color: AppColor.greyText.withOpacity(0.5)),
                  itemBuilder: (context, idx) {
                    final lesson = course.lessons![idx];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LessonPage(
                            docIdCourse: widget.docId,
                            index: idx,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Lesson: ${idx + 1}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.STYLE_14_BOLD
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
                            ),
                          ),
                          SvgPicture.asset(
                            AppImages.icArrowRightBig,
                            height: 22.0,
                            width: 22.0,
                          )
                        ],
                      ),
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
