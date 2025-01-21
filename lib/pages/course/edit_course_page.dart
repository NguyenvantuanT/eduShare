import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/pages/course/widgets/lesson_card.dart';
import 'package:chat_app/pages/lesson/make_lesson_page.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/remote/course_services.dart';
import 'package:chat_app/services/remote/storage_services.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class EditCoursePage extends StatefulWidget {
  const EditCoursePage(this.idCourse, {super.key});

  final String idCourse;

  @override
  State<EditCoursePage> createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  TextEditingController nameCourseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController describeController = TextEditingController();
  CourseServices courseServices = CourseServices();
  StorageServices storageServices = StorageServices();
  List<LessonModel> lessons = [];
  bool isLoading = false;
  bool isLoad = false;
  ImagePicker picker = ImagePicker();
  File? imgCourse;
  late CourseModel courseModel;

  Future<void> getCourse() async {
    setState(() => isLoading = true);
    courseServices
        .getCourse(widget.idCourse)
        .then((value) {
          courseModel = value;
          lessons = [...courseModel.lessons ?? []];
          nameCourseController = TextEditingController(text: courseModel.name);
          categoryController =
              TextEditingController(text: courseModel.category);
          describeController =
              TextEditingController(text: courseModel.description);
          setState(() {});
        })
        .catchError((onError) {})
        .whenComplete(() => setState(() => isLoading = false));
  }

  @override
  void initState() {
    super.initState();
    getCourse();
  }

  Future<void> pickImageCourse() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    setState(() => imgCourse = File(file.path));
  }

  Future<void> updateCourse(BuildContext context) async {
    setState(() => isLoad = true);
    courseModel.name = nameCourseController.text.trim();
    courseModel.category = categoryController.text.trim();
    courseModel.description = describeController.text.trim();
    courseModel.imageCourse = imgCourse != null
        ? await storageServices.post(image: imgCourse!)
        : courseModel.imageCourse;
    courseModel.lessons = lessons;
    debugPrint(courseModel.docId);
    courseServices.updateCourse(courseModel).then((_) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
    }).catchError((onError) {
      debugPrint(onError.toString());
    }).whenComplete(() => setState(() => isLoad = false));
  }

  void createLesson() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MakeLessonPage(
          onTap: (lesson) {
            lessons.add(lesson);
            setState(() {});
          },
        ),
      ),
    );
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
      appBar: _buildAppBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColor.blue),
            )
          : Stack(
              children: [
                Positioned.fill(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10.0)
                        .copyWith(bottom: 90.0),
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
                        controller: categoryController,
                        labelText: "e.g., biology",
                        textInputAction: TextInputAction.next,
                        validator: Validator.required,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Description ?',
                        style: AppStyles.STYLE_14_BOLD
                            .copyWith(color: AppColor.textColor),
                      ),
                      const SizedBox(height: 10.0),
                      _buildTextFieldDes(),
                      const SizedBox(height: 20.0),
                      _buildSelectImage(),
                      const SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: createLesson,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add New Lesson?',
                              style: AppStyles.STYLE_14_BOLD
                                  .copyWith(color: AppColor.textColor),
                            ),
                            Text(
                              'Tap to create lesson',
                              style: AppStyles.STYLE_14
                                  .copyWith(color: AppColor.greyText),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ListView.separated(
                        itemCount: lessons.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        separatorBuilder: (_, __) => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Divider(color: AppColor.grey, height: 1.0),
                        ),
                        itemBuilder: (context, index) {
                          final lesson = lessons[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Lesson ${index + 1}:",
                                style: AppStyles.STYLE_14_BOLD.copyWith(
                                  color: AppColor.textColor,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(child: LessonCard(lesson))
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  left: 16.0,
                  right: 16.0,
                  child: AppElevatedButton(
                    text: 'Update',
                    isDisable: isLoad,
                    onPressed: () => updateCourse(context),
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildSelectImage() {
    const radius = 30.0;
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
            ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: imgCourse != null
                    ? Container(
                        height: radius * 2,
                        width: radius * 2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(imgCourse?.path ?? ''))
                                as ImageProvider,
                          ),
                        ))
                    : CachedNetworkImage(
                        imageUrl: courseModel.imageCourse ?? '',
                        fit: BoxFit.cover,
                        height: radius * 2,
                        width: radius * 2,
                        errorWidget: (context, __, ___) {
                          return Container(
                            height: radius * 2,
                            width: radius * 2,
                            color: AppColor.blue,
                            child: const Center(
                              child: Icon(Icons.error_rounded,
                                  color: AppColor.white),
                            ),
                          );
                        },
                        placeholder: (context, __) {
                          return const SizedBox.square(
                            dimension: radius * 2,
                            child: Center(
                              child: SizedBox.square(
                                dimension: 26.0,
                                child: CircularProgressIndicator(
                                  color: AppColor.white,
                                  strokeWidth: 2.0,
                                ),
                              ),
                            ),
                          );
                        },
                      )),
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
          labelText: 'e.g., describe',
          labelStyle: AppStyles.STYLE_14.copyWith(
            color: AppColor.textColor,
          )),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.blue,
      scrolledUnderElevation: 0,
      title: Text(
        'Edit Course',
        style: AppStyles.STYLE_18_BOLD.copyWith(color: AppColor.white),
      ),
    );
  }
}
