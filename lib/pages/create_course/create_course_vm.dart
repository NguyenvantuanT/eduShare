import 'dart:io';

import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/course_services.dart';
import 'package:chat_app/services/remote/storage_services.dart';
import 'package:chat_app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class CreateCourseVM extends BaseViewModel{
  final nameCourseController = TextEditingController();
  final categoryController = TextEditingController();
  final describeController = TextEditingController();
  ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  CourseServices courseServices = CourseServices();
  StorageServices storageServices = StorageServices();
  File? imageCourse;
  bool isLoading = false;
  bool showMenu = false;

  void showBotMenu() {
    showMenu = !showMenu;
    rebuildUi();
  }

  void pickCategory(CategoryType category) {
     categoryController.text = category.name;
     rebuildUi();
  }

  Future<void> pickImageCourse() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
   imageCourse = File(file.path);
   rebuildUi();
  }

  Future<void> addCourse(BuildContext context) async {
    if (formKey.currentState?.validate() == false) return;
    isLoading = true;
    rebuildUi();

    CourseModel course = CourseModel()
      ..id = '${DateTime.now().millisecondsSinceEpoch}'
      ..name = nameCourseController.text.trim()
      ..createBy = SharedPrefs.user?.email ?? ""
      ..category = categoryController.text.trim()
      ..description = describeController.text.trim()
      ..imageCourse = imageCourse != null
          ? await storageServices.post(image: imageCourse!)
          : null;

    courseServices.createCourse(course).then((_) {
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const MainPage(index: 4),
        ),
        (route) => false,
      );
      DelightToastShow.showToast(
          context: context, text: 'Your course is create😐', icon: Icons.check);
    }).catchError((onError) {
      debugPrint("Failed to post: $onError");
    }).whenComplete(() {
      isLoading = false;
      rebuildUi();
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameCourseController.dispose();
    categoryController.dispose();
    describeController.dispose();
  }
}