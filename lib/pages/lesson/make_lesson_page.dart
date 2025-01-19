
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';

class MakeLessonPage extends StatelessWidget {
  const MakeLessonPage({super.key, this.onTap});

  final Function(LessonModel)? onTap;

  @override
  Widget build(BuildContext context) {
    final nameLessonsController = TextEditingController();
    final describeController = TextEditingController();
    final videoPathController = TextEditingController();
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0 , vertical: 10.0),
        children: [
          Text(
            'Name Your Lesson?',
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
          ),
          const SizedBox(height: 10.0),
          AppTextField(
            controller: nameLessonsController,
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
          buildTextFieldDes(describeController),
          const SizedBox(height: 20.0),
          Text(
            'Link Video?',
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
          ),
          const SizedBox(height: 10.0),
          AppTextField(
            controller: videoPathController,
            labelText: "e.g., path ...",
            textInputAction: TextInputAction.done,
            validator: Validator.required,
          ),
          const SizedBox(height: 30.0),
          AppElevatedButton(
            text: 'Save',
            onPressed: () {
              LessonModel lesson = LessonModel()
                ..id = '${DateTime.now().millisecondsSinceEpoch}'
                ..name = nameLessonsController.text.trim()
                ..description = describeController.text.trim()
                ..videoPath = videoPathController.text.trim();
              onTap?.call(lesson);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.blue,
      scrolledUnderElevation: 0,
      title: Text(
        'Add Lesson',
        style: AppStyles.STYLE_18_BOLD.copyWith(color: AppColor.white),
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
