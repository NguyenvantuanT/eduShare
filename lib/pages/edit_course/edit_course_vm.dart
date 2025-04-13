import 'dart:io';

import 'package:chat_app/components/app_dialog.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/models/quiz_model.dart';
import 'package:chat_app/pages/create_lesson/create_lesson_page.dart';
import 'package:chat_app/pages/create_quiz/create_quiz_page.dart';
import 'package:chat_app/pages/edit_lesson/edit_lesson_page.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/services/remote/course_services.dart';
import 'package:chat_app/services/remote/lesson_services.dart';
import 'package:chat_app/services/remote/quiz_services.dart';
import 'package:chat_app/services/remote/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class EditCourseVM extends BaseViewModel {
  EditCourseVM(this.docId);
  final String docId;

  TextEditingController nameCourseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController describeController = TextEditingController();
  CourseServices courseServices = CourseServices();
  StorageServices storageServices = StorageServices();
  LessonServices lessonServices = LessonServices();
  QuizServices quizServices = QuizServices();
  List<LessonModel> lessons = [];
  List<QuizModel> quizs = [];
  bool isLoading = false;
  bool isLoad = false;
  ImagePicker picker = ImagePicker();
  File? imgCourse;
  late CourseModel courseModel;

  void onInit() {
    getCourse();
  }

  Future<void> getCourse() async {
    isLoading = true;
    rebuildUi();
    courseServices
        .getCourse(docId)
        .then((value) async {
          courseModel = value;
          nameCourseController.text = courseModel.name ?? "";
          categoryController.text = courseModel.category ?? "";
          describeController.text = courseModel.description ?? "";
          lessons = await lessonServices.getLessons(docId);
          getQuizs();
        })
        .catchError((onError) {})
        .whenComplete(() {
          isLoading = false;
          rebuildUi();
        });
  }

  void getQuizs() async {
    quizs = await quizServices.getQuizs(docId) ?? [];
    rebuildUi();
  }

  Future<void> pickImageCourse() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    imgCourse = File(file.path);
    rebuildUi();
  }

  Future<void> updateCourse(BuildContext context) async {
    isLoad = true;
    rebuildUi();
    courseModel.name = nameCourseController.text.trim();
    courseModel.category = categoryController.text.trim();
    courseModel.description = describeController.text.trim();
    courseModel.imageCourse = imgCourse != null
        ? await storageServices.post(image: imgCourse!)
        : courseModel.imageCourse;
    courseServices.updateCourse(courseModel).then((_) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }).catchError((onError) {
      debugPrint(onError.toString());
    }).whenComplete(() {
      isLoad = false;
      rebuildUi();
    });
  }

  void createLesson(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            CreateLessonPage(docIdCourse: docId, onUpdate: getCourse),
      ),
    );
  }

  void createQuiz(BuildContext context, {QuizModel? quiz}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateQuizPage(
          courseId: docId,
          onUpdate: getQuizs,
          quiz: quiz,
        ),
      ),
    );
  }

  void editLesson(BuildContext context, LessonModel value) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditLessonPage(
            lessonId: value.lessonId ?? '',
            courseId: docId,
            onUpdate: getCourse),
      ),
    );
  }

  void deleteLesson(BuildContext context, String lessonId) {
    if (!context.mounted) return;
    AppDialog.dialog(
      context,
      title: const Align(
        alignment: Alignment.topLeft,
        child: Icon(
          Icons.delete,
          color: AppColor.blue,
        ),
      ),
      content: "Your want delete lesson 🥲",
      action: () {
        lessonServices.deleteLesson(docId, lessonId).then((_) {
          lessons.removeWhere((e) => e.lessonId == lessonId);
          rebuildUi();
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameCourseController.dispose();
    categoryController.dispose();
    describeController.dispose();
  }
}
