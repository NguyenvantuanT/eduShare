import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';

class EditLessonPage extends StatefulWidget {
  const EditLessonPage(this.lessonModel, {super.key, this.onEdit});

  final Function(LessonModel)? onEdit;
  final LessonModel lessonModel;

  @override
  State<EditLessonPage> createState() => _EditLessonPageState();
}

class _EditLessonPageState extends State<EditLessonPage> {
  final nameLessonsController = TextEditingController();
  final describeController = TextEditingController();
  final videoPathController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameLessonsController.text = widget.lessonModel.name ?? "";
    describeController.text = widget.lessonModel.description ?? "";
    videoPathController.text = widget.lessonModel.videoPath ?? "";
  }

  @override
  Widget build(BuildContext context) {
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
              widget.lessonModel
                ..name = nameLessonsController.text.trim()
                ..description = describeController.text.trim()
                ..videoPath = videoPathController.text.trim();
              widget.onEdit?.call(widget.lessonModel);
              Navigator.pop(context);
            },
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
