import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/pages/edit_lesson/edit_lesson_vm.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class EditLessonPage extends StackedView<EditLessonVM> {
  const EditLessonPage({
    super.key,
    this.onUpdate,
    required this.lessonId,
    required this.courseId,
  });

  final Function()? onUpdate;
  final String lessonId;
  final String courseId;

  @override
  void onViewModelReady(EditLessonVM viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.onInit();
  }

  @override
  EditLessonVM viewModelBuilder(BuildContext context) {
    return EditLessonVM(lessonId: lessonId, courseId: courseId);
  }

  @override
  Widget builder(BuildContext context, EditLessonVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: const AppTabBarBlue(title: 'Edit Lesson'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        children: [
          Text(
            'Name Your Lesson?',
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
          ),
          const SizedBox(height: 10.0),
          AppTextField(
            controller: viewModel.nameLessonsController,
            labelText: "e.g., lesson ...",
            textInputAction: TextInputAction.next,
            validator: Validator.required,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Description ?',
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
          ),
          const SizedBox(height: 10.0),
          buildTextFieldDes(viewModel.describeController),
          const SizedBox(height: 20.0),
          Text(
            'Link Video?',
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
          ),
          const SizedBox(height: 10.0),
          AppTextField(
            controller: viewModel.videoPathController,
            labelText: "e.g., path ...",
            textInputAction: TextInputAction.done,
            validator: Validator.required,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Change File?',
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
          ),
          if (viewModel.file != null) ...[
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              decoration: const BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  boxShadow: AppShadow.boxShadowContainer),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected File:',
                    style: AppStyles.STYLE_14_BOLD
                        .copyWith(color: AppColor.textColor),
                  ),
                  Text(viewModel.file!.path.split('/').last),
                  Text(
                    'Size: ${(viewModel.file!.lengthSync() / 1024).toStringAsFixed(2)} KB',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
          ],
          AppElevatedButton.outline(
            text: "Enter to change file",
            onPressed: viewModel.pickFile,
          ),
          const SizedBox(height: 30.0),
          AppElevatedButton(
            text: 'Save',
            isDisable: viewModel.isLoading,
            onPressed: () => viewModel.updateLesson(context),
          ),
        ],
      ),
    );
  }

  TextField buildTextFieldDes(TextEditingController describeController) {
    OutlineInputBorder outlineInputBorder(Color color) => OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1.2),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        );
    return TextField(
      maxLines: 5,
      textAlign: TextAlign.start,
      controller: describeController,
      decoration: InputDecoration(
          border: outlineInputBorder(AppColor.grey),
          focusedBorder: outlineInputBorder(AppColor.grey),
          enabledBorder: outlineInputBorder(AppColor.grey),
          labelText: 'e.g., describe...',
          labelStyle: AppStyles.STYLE_14.copyWith(
            color: AppColor.textColor,
          )),
    );
  }
}
