import 'dart:io';

import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/services/remote/lesson_services.dart';
import 'package:chat_app/services/remote/storage_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class EditLessonVM extends BaseViewModel {
  EditLessonVM({
    this.onUpdate,
    required this.lessonId,
    required this.courseId,
  });
  final Function()? onUpdate;
  final String lessonId;
  final String courseId;

  final nameLessonsController = TextEditingController();
  final describeController = TextEditingController();
  final videoPathController = TextEditingController();
  StorageServices storageServices = StorageServices();
  LessonServices lessonServices = LessonServices();
  LessonModel lesson = LessonModel();
  bool isLoading = false;
  File? file;

  void onInit() {
    getLesson();
  }


  void getLesson() {
    isLoading = true;
    rebuildUi();
    lessonServices.getLesson(courseId,lessonId).then((value) {
      lesson = value;
      nameLessonsController.text = lesson.name ?? "";
      describeController.text = lesson.description ?? "";
      videoPathController.text = lesson.videoPath ?? "";
      isLoading = false;
      rebuildUi();
    });
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result == null) return;
    file = File(result.files.single.path!);
    rebuildUi();
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
      onUpdate?.call();
      lessonServices.updateLesson(courseId, lesson).then((_) {
      if (!context.mounted) return;
      Navigator.pop(context);
    });
  }

}
