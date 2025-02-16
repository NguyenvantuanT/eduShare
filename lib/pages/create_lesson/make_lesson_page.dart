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

class MakeLessonPage extends StatefulWidget {
  const MakeLessonPage({super.key, this.onUpdate, required this.docIdCourse});

  final Function()? onUpdate;
  final String docIdCourse;

  @override
  State<MakeLessonPage> createState() => _MakeLessonPageState();
}

class _MakeLessonPageState extends State<MakeLessonPage> {
  final nameLessonsController = TextEditingController();
  final describeController = TextEditingController();
  final videoPathController = TextEditingController();
  StorageServices storageServices = StorageServices();
  LessonServices lessonServices = LessonServices();
  File? file;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result == null) return;
    file = File(result.files.single.path!);
    setState(() {});
  }

  void createLesson(BuildContext context) async {
    String fileName = file!.path.split('/').last;
    LessonModel lesson = LessonModel()
      ..id = '${DateTime.now().millisecondsSinceEpoch}'
      ..name = nameLessonsController.text.trim()
      ..description = describeController.text.trim()
      ..videoPath = videoPathController.text.trim()
      ..fileName = fileName
      ..filePath = file != null
          ? await storageServices.postFile(fileName: fileName, file: file!)
          : null;
    widget.onUpdate?.call();
    lessonServices.createLesson(widget.docIdCourse, lesson).then((_) {
      if (!context.mounted) return;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 10.0),
          AppElevatedButton.outline(
            text: "Enter to chose file",
            onPressed: pickFile,
          ),
          const SizedBox(height: 20.0),
          AppElevatedButton(
            text: 'Save',
            onPressed: () => createLesson(context),
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
