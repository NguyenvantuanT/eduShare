import 'dart:io';

import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/course_services.dart';
import 'package:chat_app/services/remote/storage_services.dart';
import 'package:chat_app/utils/enum.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class MakeCoursePage extends StatefulWidget {
  const MakeCoursePage({super.key});

  @override
  State<MakeCoursePage> createState() => _MakeCoursePageState();
}

class _MakeCoursePageState extends State<MakeCoursePage> {
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

  Future<void> pickImageCourse() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() => imageCourse = File(file.path));
  }

  Future<void> _addCourse(BuildContext context) async {
    if (formKey.currentState?.validate() == false) return;
    setState(() => isLoading = true);

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
    }).whenComplete(() => setState(() => isLoading = false));
  }

  @override
  void dispose() {
    super.dispose();
    nameCourseController.dispose();
    categoryController.dispose();
    describeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 6.0),
          Stack(
            children: [
              SvgPicture.asset(AppImages.imageMakeCourse),
              Positioned(
                left: 30.0,
                right: 30.0,
                bottom: 90.0,
                child: Text(
                  "What do You Want to make today",
                  textAlign: TextAlign.center,
                  style: AppStyles.STYLE_24.copyWith(
                    color: AppColor.white,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Name Your Course?',
                    style: AppStyles.STYLE_14_BOLD
                        .copyWith(color: AppColor.textColor),
                  ),
                  const SizedBox(height: 10.0),
                  AppTextField(
                    controller: nameCourseController,
                    labelText: "e.g., how to ...",
                    textInputAction: TextInputAction.next,
                    validator: Validator.required,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    'Name Category?',
                    style: AppStyles.STYLE_14_BOLD
                        .copyWith(color: AppColor.textColor),
                  ),
                  const SizedBox(height: 10.0),
                  AppTextField(
                    readOnly: true,
                    onTap: () => setState(() => showMenu = !showMenu),
                    controller: categoryController,
                    hintText: "e.g., biology",
                    hintTextColor: AppColor.textColor,
                    textInputAction: TextInputAction.next,
                    validator: Validator.required,
                  ),
                  if (showMenu)
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.bgColor,
                        boxShadow: AppShadow.boxShadowContainer,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children:
                            List.generate(CategoryType.values.length, (idx) {
                          final category = CategoryType.values[idx];
                          return InkWell(
                              onTap: () => setState(() {
                                    categoryController.text = category.name;
                                  }),
                              child: Container(
                                height: 30.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color:
                                        categoryController.text == category.name
                                            ? AppColor.blue
                                            : null),
                                child: Text(
                                  category.name,
                                  style: AppStyles.STYLE_14.copyWith(
                                      color: categoryController.text ==
                                              category.name
                                          ? AppColor.bgColor
                                          : AppColor.textColor),
                                ),
                              ));
                        }),
                      ),
                    ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Description ?',
                    style: AppStyles.STYLE_14_BOLD
                        .copyWith(color: AppColor.textColor),
                  ),
                  const SizedBox(height: 10.0),
                  _buildTextFieldDes(),
                  const SizedBox(height: 10.0),
                  _buildSelectImage(),
                  const SizedBox(height: 50.0),
                  AppElevatedButton(
                    isDisable: isLoading,
                    text: 'Make Course',
                    onPressed: () => _addCourse(context),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  TextField _buildTextFieldDes() {
    OutlineInputBorder outlineInputBorder(Color color) => OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1.2),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        );
    return TextField(
      maxLines: 5,
      controller: describeController,
      decoration: InputDecoration(
          border: outlineInputBorder(AppColor.grey),
          focusedBorder: outlineInputBorder(AppColor.grey),
          hintText: 'e.g., describe',
          hintStyle: AppStyles.STYLE_14.copyWith(
            color: AppColor.textColor,
          )),
    );
  }

  Widget _buildSelectImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Images Course?',
          style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              height: 64.0,
              width: 64.0,
              alignment: Alignment.topRight,
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.blue),
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: imageCourse == null
                      ? Image.asset(AppImages.imageLogoPng).image
                      : FileImage(imageCourse!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            GestureDetector(
              onTap: pickImageCourse,
              child: Container(
                  height: 60.0,
                  width: 60.0,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: AppColor.greyText, width: 1.2),
                    color: AppColor.white,
                  ),
                  child: SvgPicture.asset(AppImages.iconCamera)),
            ),
          ],
        ),
      ],
    );
  }
}
