
import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/pages/create_lesson/create_lesson_vm.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CreateLessonPage extends StackedView<CreateLessonVM> {
  const CreateLessonPage({super.key, this.onUpdate, required this.docIdCourse});

  final Function()? onUpdate;
  final String docIdCourse;

  @override
  CreateLessonVM viewModelBuilder(BuildContext context) =>
      CreateLessonVM(docIdCourse: docIdCourse, onUpdate: onUpdate);

  @override
  Widget builder(BuildContext context, CreateLessonVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: const AppTabBarBlue(title: 'Add Lesson'),
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
          const SizedBox(height: 10.0),
          Text(
            'Hãy đăng video lên youtube sau đó copy link và chỉ lấy đuôi ',
            style: AppStyles.STYLE_12.copyWith(color: AppColor.greyText),
          ),
          Text(
            'ví dụ: https://youtu.be/hFtPNzP-6v8 lấy phần <hFtPNzP-6v8>',
            style: AppStyles.STYLE_12.copyWith(color: AppColor.greyText),
          ),
          const SizedBox(height: 20.0),
          Text(
            'Upload File?',
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
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 10.0),
          AppElevatedButton.outline(
            text: "Enter to chose file",
            onPressed: viewModel.pickFile,
          ),
          const SizedBox(height: 20.0),
          AppElevatedButton(
            text: 'Save',
            onPressed: () => viewModel.createLesson(context),
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

