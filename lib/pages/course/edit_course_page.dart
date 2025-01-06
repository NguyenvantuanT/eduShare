import 'package:chat_app/components/app_dialog.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/course_services.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';

class EditCoursePage extends StatefulWidget {
  const EditCoursePage( {super.key , required this. course});
  final CourseModel course;

  @override
  State<EditCoursePage> createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  TextEditingController nameCourseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController describeController = TextEditingController();
  CourseServices courseServices = CourseServices();
  List<LessonModel> lessons = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    lessons = [...widget.course.lessons ?? []];
    nameCourseController = TextEditingController(text: widget.course.name);
    categoryController = TextEditingController(text: widget.course.category);
    describeController = TextEditingController(text: widget.course.description);
  }

  Future<void> updateCourse(BuildContext context) async {
    setState(() => isLoading = true);

    widget.course
      ..name = nameCourseController.text.trim()
      ..category = categoryController.text.trim()
      ..createBy = SharedPrefs.user?.email ?? ""
      ..description = describeController.text.trim()
      ..lessons = lessons;

    courseServices.updateCourse(widget.course).then((_) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          Text(
            'Name Your Course?',
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
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
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
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
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
          ),
          const SizedBox(height: 10.0),
          _buildTextFieldDes(),
          const SizedBox(height: 20.0),
          GestureDetector(
            onTap: () async {
              LessonModel? lesson = await AppDialog.showModal(
                  context, widget.course.lessons ?? []);
              if (lesson == null) return;
              lessons.add(lesson);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Lesson?',
                  style: AppStyles.STYLE_14_BOLD
                      .copyWith(color: AppColor.textColor),
                ),
                Text(
                  'Tap to add or edit lesson',
                  style: AppStyles.STYLE_14.copyWith(color: AppColor.greyText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          ...List.generate(lessons.length, (idx) {
            LessonModel lesson = lessons.reversed.toList()[idx];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lesson: ${idx + 1}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.STYLE_14.copyWith(color: AppColor.textColor),
                ),
                Text(
                  lesson.name ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.STYLE_14.copyWith(color: AppColor.textColor),
                ),
                const SizedBox(height: 5.0),
                Text(
                  'Tap to edit lesson',
                  style: AppStyles.STYLE_14.copyWith(color: AppColor.greyText),
                ),
                Divider(color: AppColor.greyText.withOpacity(0.5),)
              ],
            );
          }),
          const SizedBox(height: 20.0),
          AppElevatedButton(
            text: 'Update',
            isDisable: isLoading,
            onPressed: () => updateCourse(context),
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
          labelText: 'e.g., describe',
          labelStyle: AppStyles.STYLE_14.copyWith(
            color: AppColor.textColor,
          )),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.bgColor,
      title: Text(
        'Edit Course',
        style: AppStyles.STYLE_18_BOLD.copyWith(color: AppColor.textColor),
      ),
    );
  }
}
