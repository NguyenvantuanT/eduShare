import 'dart:io';

import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/services/remote/lesson_services.dart';
import 'package:chat_app/services/remote/storage_services.dart';
import 'package:chat_app/utils/app_function.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CreateLessonVM extends BaseViewModel {
  CreateLessonVM({this.onUpdate, required this.docIdCourse});
  final Function()? onUpdate;
  final String docIdCourse;

  final nameLessonsController = TextEditingController();
  final describeController = TextEditingController();
  final videoPathController = TextEditingController();
  StorageServices storageServices = StorageServices();
  LessonServices lessonServices = LessonServices();
  File? file;
  String? fileName ;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result == null) return;
    file = File(result.files.single.path!);
    fileName = file!.path.split('/').last;
    rebuildUi();
  }

  void createLesson(BuildContext context) async {
    final videoPath = AppFunction.converLinkYoutube(videoPathController.text.trim());
    LessonModel lesson = LessonModel()
      ..id = '${DateTime.now().millisecondsSinceEpoch}'
      ..name = nameLessonsController.text.trim()
      ..description = describeController.text.trim()
      ..videoPath = videoPath
      ..fileName = fileName
      ..filePath = file != null
          ? await storageServices.postFile(fileName: fileName ?? '', file: file!)
          : null;
    onUpdate?.call();
    lessonServices.createLesson(docIdCourse, lesson).then((_) {
      if (!context.mounted) return;
      Navigator.pop(context);
    });
  }
}
