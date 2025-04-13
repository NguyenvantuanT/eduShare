import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/app_drop_down.dart';
import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/components/mv_simmer.dart';
import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/pages/course_detail/course_detail_vm.dart';
import 'package:chat_app/pages/course_detail/widgets/comment_card.dart';
import 'package:chat_app/pages/course_detail/widgets/course_button.dart';
import 'package:chat_app/pages/lesson/lesson_page.dart';
import 'package:chat_app/pages/quiz/quiz_page.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';
import 'package:stacked/stacked.dart';

class CourseDetailPage extends StackedView<CourseDetailVM> {
  const CourseDetailPage(this.docId, {super.key, this.onUpdate});

  final String docId;
  final VoidCallback? onUpdate;

  @override
  void onViewModelReady(CourseDetailVM viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.onInit();
  }

  @override
  CourseDetailVM viewModelBuilder(BuildContext context) =>
      CourseDetailVM(docId, onUpdate: onUpdate);

  @override
  Widget builder(
      BuildContext context, CourseDetailVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: ListView(
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: viewModel.course.imageCourse ?? "",
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
                          viewModel.course.name ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.STYLE_18
                              .copyWith(color: AppColor.textColor),
                        ),
                        Text(
                          viewModel.course.createBy ?? "",
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
                        viewModel.course.category ?? "",
                        style:
                            AppStyles.STYLE_14.copyWith(color: AppColor.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    CourseButton(
                      text: "Add to learn",
                      onTap: () => viewModel.toggleLearning(context),
                      isLearning: viewModel.isLearning,
                    ),
                    GestureDetector(
                      onTap: () => viewModel.toggleFavorite(context),
                      child: viewModel.isFavorite
                          ? const Icon(
                              Icons.favorite,
                              color: AppColor.blue,
                            )
                          : const Icon(
                              Icons.favorite_outline,
                              color: AppColor.greyText,
                            ),
                    ),
                    const Spacer(),
                    CourseButton(
                      text: "Add to Todo",
                      onTap: () => viewModel.addCourseTodo(context),
                      icon: AppImages.iconTodo,
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Description',
                  style: AppStyles.STYLE_16_BOLD
                      .copyWith(color: AppColor.textColor),
                ),
                const SizedBox(height: 15.0),
                ReadMoreText(
                  viewModel.course.description ?? "",
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
                const SizedBox(height: 20.0),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20.0),
                  itemCount: viewModel.lessons.length,
                  separatorBuilder: (_, __) =>
                      Divider(color: AppColor.greyText.withOpacity(0.5)),
                  itemBuilder: (context, idx) {
                    final lesson = viewModel.lessons[idx];
                    return _buildLessonCard(context,
                        idx: idx, lesson: lesson, viewModel: viewModel);
                  },
                ),
                const Divider(color: AppColor.blue),
                const SizedBox(height: 15.0),
                Text(
                  'Quizzes',
                  style: AppStyles.STYLE_16_BOLD
                      .copyWith(color: AppColor.textColor),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Difficulty:',
                      style: AppStyles.STYLE_14_BOLD
                          .copyWith(color: AppColor.textColor),
                    ),
                    SizedBox(
                      width: 120.0,
                      child: AppDropDown<DifficultyLevel>(
                        items: DifficultyLevel.values,
                        selectedItem: viewModel.selectedDifficulty,
                        onChanged: viewModel.selectDifficulty,
                        itemBuilder: (value) {
                          return Text(
                            value.name,
                            style: AppStyles.STYLE_14.copyWith(
                              color: value == DifficultyLevel.easy
                                  ? AppColor.green
                                  : value == DifficultyLevel.normal
                                      ? AppColor.blue
                                      : AppColor.red,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                _buildQuizSection(context, viewModel),
                const SizedBox(height: 25.0),
                Text(
                  'Comment',
                  style: AppStyles.STYLE_16_BOLD
                      .copyWith(color: AppColor.textColor),
                ),
                const SizedBox(height: 15.0),
                _buildTextFieldDes(viewModel),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 20.0, bottom: 50.0),
                  itemCount: viewModel.comments.length,
                  separatorBuilder: (_, __) =>
                      Divider(color: AppColor.greyText.withOpacity(0.5)),
                  itemBuilder: (context, idx) {
                    final comment = viewModel.comments[idx];
                    return CommentCard(
                      comment,
                      onRatingUpdate: (rating) {
                        viewModel.updateRating(comment, rating);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizSection(BuildContext context, CourseDetailVM viewModel) {
    if (viewModel.selectedDifficulty == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          "Please select a difficulty level",
          style: AppStyles.STYLE_14,
        ),
      );
    }

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => QuizPage(
            docId,
            level: viewModel.selectedDifficulty,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: AppShadow.boxShadowContainer),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "${viewModel.selectedDifficulty?.name} Quizzes",
                style: AppStyles.STYLE_14.copyWith(
                  color: viewModel.selectedDifficulty == DifficultyLevel.easy
                      ? AppColor.green
                      : viewModel.selectedDifficulty == DifficultyLevel.normal
                          ? AppColor.blue
                          : AppColor.red,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16.0,
              color: AppColor.blue,
            ),
          ],
        ),
      ),
    );
  }

  TextField _buildTextFieldDes(CourseDetailVM viewModel) {
    OutlineInputBorder outlineInputBorder(Color color) => OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1.2),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        );
    return TextField(
      maxLines: 2,
      controller: viewModel.commentController,
      decoration: InputDecoration(
        border: outlineInputBorder(AppColor.grey),
        focusedBorder: outlineInputBorder(AppColor.grey),
        hintText: 'Your comment..',
        suffixIcon: InkWell(
          onTap: viewModel.createComment,
          child: const Icon(
            Icons.send,
            color: AppColor.blue,
            size: 18.0,
          ),
        ),
        hintStyle: AppStyles.STYLE_14.copyWith(
          color: AppColor.textColor,
        ),
      ),
    );
  }

  Widget _buildLessonCard(
    BuildContext context, {
    required int idx,
    required LessonModel lesson,
    required CourseDetailVM viewModel,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LessonPage(
            docIdCourse: docId,
            index: idx,
            updateProg: viewModel.getProgress,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: AppStyles.STYLE_14.copyWith(color: AppColor.textColor),
                ),
                const SizedBox(height: 10.0),
                LinearProgressIndicator(
                  value: lesson.progress,
                  minHeight: 8.0,
                  backgroundColor: AppColor.grey,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColor.blue),
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
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
