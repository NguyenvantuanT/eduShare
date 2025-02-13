import 'dart:io';

import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/remote/lesson_services.dart';
import 'package:chat_app/services/remote/storage_services.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class EditLessonPage extends StatefulWidget {
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
  State<EditLessonPage> createState() => _EditLessonPageState();
}

class _EditLessonPageState extends State<EditLessonPage> {
  final nameLessonsController = TextEditingController();
  final describeController = TextEditingController();
  final videoPathController = TextEditingController();
  StorageServices storageServices = StorageServices();
  LessonServices lessonServices = LessonServices();
  LessonModel lesson = LessonModel();
  bool isLoading = false;
  File? file;

  @override
  void initState() {
    super.initState();
    getLesson();
  }

  void getLesson() {
    setState(() => isLoading = true);
    lessonServices.getLesson(widget.courseId, widget.lessonId).then((value) {
      lesson = value;
      nameLessonsController.text = lesson.name ?? "";
      describeController.text = lesson.description ?? "";
      videoPathController.text = lesson.videoPath ?? "";
      setState(() => isLoading = false);
    });
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result == null) return;
    file = File(result.files.single.path!);
    setState(() {});
  }

  void updateLesson(BuildContext context) async {
    String fileName = file!.path.split('/').last;
      lesson.name = nameLessonsController.text.trim();
      lesson.description = describeController.text.trim();
      lesson.videoPath = videoPathController.text.trim();
      lesson.fileName = fileName;
      lesson.filePath = file != null
          ? await storageServices.postFile(fileName: fileName, file: file!)
          : lesson.filePath;
      widget.onUpdate?.call();
      lessonServices.updateLesson(widget.courseId, lesson).then((_) {
      if (!context.mounted) return;
      Navigator.pop(context);
    });
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
          const SizedBox(height: 20.0),
          Text(
            'Change File?',
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
          ),
          if (file != null) ...[
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
                  Text(file!.path.split('/').last),
                  Text(
                    'Size: ${(file!.lengthSync() / 1024).toStringAsFixed(2)} KB',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
          ],
          AppElevatedButton.outline(
            text: "Enter to change file",
            onPressed: pickFile,
          ),
          const SizedBox(height: 30.0),
          AppElevatedButton(
            text: 'Save',
            isDisable: isLoading,
            onPressed: () => updateLesson(context),
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
