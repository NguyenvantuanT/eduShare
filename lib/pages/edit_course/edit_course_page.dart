import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/pages/course/widgets/lesson_card.dart';
import 'package:chat_app/pages/edit_course/edit_course_vm.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

class EditCoursePage extends StackedView<EditCourseVM> {
  const EditCoursePage(this.docId, {super.key});
  final String docId;

  @override
  void onViewModelReady(EditCourseVM viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.onInit();
  }

  @override
  EditCourseVM viewModelBuilder(BuildContext context) => EditCourseVM(docId);

  @override
  Widget builder(BuildContext context, EditCourseVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: const AppTabBarBlue(title: "Edit Course"),
      body: viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColor.blue),
            )
          : Stack(
              children: [
                Positioned.fill(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0)
                        .copyWith(bottom: 120.0),
                    children: [
                      Text(
                        'Name Your Course?',
                        style: AppStyles.STYLE_14_BOLD
                            .copyWith(color: AppColor.textColor),
                      ),
                      const SizedBox(height: 10.0),
                      AppTextField(
                        controller: viewModel.nameCourseController,
                        labelText: "e.g., how to ...",
                        textInputAction: TextInputAction.next,
                        validator: Validator.required,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Name Category?',
                        style: AppStyles.STYLE_14_BOLD
                            .copyWith(color: AppColor.textColor),
                      ),
                      const SizedBox(height: 10.0),
                      AppTextField(
                        controller: viewModel.categoryController,
                        labelText: "e.g., biology",
                        textInputAction: TextInputAction.next,
                        validator: Validator.required,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Description ?',
                        style: AppStyles.STYLE_14_BOLD
                            .copyWith(color: AppColor.textColor),
                      ),
                      const SizedBox(height: 10.0),
                      _buildTextFieldDes(viewModel),
                      const SizedBox(height: 20.0),
                      _buildSelectImage(viewModel),
                      const SizedBox(height: 20.0),
                      const Divider(color: AppColor.blue),
                      const SizedBox(height: 10.0),
                      GestureDetector(
                        onTap:() => viewModel.createLesson(context),
                        behavior: HitTestBehavior.translucent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add New Lesson?',
                              style: AppStyles.STYLE_14_BOLD
                                  .copyWith(color: AppColor.textColor),
                            ),
                            Text(
                              'Tap to create lesson',
                              style: AppStyles.STYLE_14
                                  .copyWith(color: AppColor.greyText),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ListView.separated(
                        itemCount: viewModel.lessons.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        separatorBuilder: (_, __) => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(color: AppColor.grey, height: 1.0),
                        ),
                        itemBuilder: (context, index) {
                          final lesson = viewModel.lessons[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Lesson ${index + 1}:",
                                style: AppStyles.STYLE_14_BOLD.copyWith(
                                  color: AppColor.textColor,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: LessonCard(
                                  lesson,
                                  onEdit: () => viewModel.editLesson(context,lesson),
                                  onDelete: () => viewModel.deleteLesson(
                                      context, lesson.lessonId ?? ""),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20.0),
                      const Divider(color: AppColor.blue),
                      const SizedBox(height: 10.0),
                      GestureDetector(
                        onTap:() => viewModel.createQuiz(context),
                        behavior: HitTestBehavior.translucent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Quiz?',
                              style: AppStyles.STYLE_14_BOLD
                                  .copyWith(color: AppColor.textColor),
                            ),
                            Text(
                              'Tap to create Quiz',
                              style: AppStyles.STYLE_14
                                  .copyWith(color: AppColor.greyText),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ListView.separated(
                        itemCount: viewModel.quizs.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        separatorBuilder: (_, __) => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Divider(color: AppColor.grey, height: 1.0),
                        ),
                        itemBuilder: (context, index) {
                          final quiz = viewModel.quizs[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Quiz ${index + 1}:",
                                style: AppStyles.STYLE_14_BOLD.copyWith(
                                  color: AppColor.textColor,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                  quiz.question ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => viewModel.createQuiz(context,quiz : quiz),
                                child: const Icon(Icons.edit , color: AppColor.blue))
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  left: 16.0,
                  right: 16.0,
                  child: AppElevatedButton(
                    text: 'Update',
                    isDisable: viewModel.isLoad,
                    onPressed: () => viewModel.updateCourse(context),
                  ),
                )
              ],
            ),
    );
  }
  Widget _buildSelectImage(EditCourseVM viewModel) {
    const radius = 30.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Images Course?',
          style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: viewModel.imgCourse != null
                    ? Container(
                        height: radius * 2,
                        width: radius * 2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(viewModel.imgCourse?.path ?? ''))
                                as ImageProvider,
                          ),
                        ))
                    : CachedNetworkImage(
                        imageUrl: viewModel.courseModel.imageCourse ?? '',
                        fit: BoxFit.cover,
                        height: radius * 2,
                        width: radius * 2,
                        errorWidget: (context, __, ___) {
                          return Container(
                            height: radius * 2,
                            width: radius * 2,
                            color: AppColor.blue,
                            child: const Center(
                              child: Icon(Icons.error_rounded,
                                  color: AppColor.white),
                            ),
                          );
                        },
                        placeholder: (context, __) {
                          return const SizedBox.square(
                            dimension: radius * 2,
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
                      )),
            const SizedBox(width: 10.0),
            GestureDetector(
              onTap: viewModel.pickImageCourse,
              child: Container(
                  height: 60.0,
                  width: 60.0,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: AppColor.greyText, width: 1.2),
                    color: AppColor.white,
                  ),
                  child: SvgPicture.asset(AppImages.iconCamera)),
            ),
          ],
        ),
      ],
    );
  }

  TextField _buildTextFieldDes(EditCourseVM viewModel) {
    OutlineInputBorder outlineInputBorder(Color color) => OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1.2),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        );
    return TextField(
      maxLines: 5,
      controller: viewModel.describeController,
      decoration: InputDecoration(
          border: outlineInputBorder(AppColor.grey),
          focusedBorder: outlineInputBorder(AppColor.grey),
          labelText: 'e.g., describe',
          labelStyle: AppStyles.STYLE_14.copyWith(
            color: AppColor.textColor,
          )),
    );
  }
  
}

