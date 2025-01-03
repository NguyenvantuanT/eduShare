import 'package:chat_app/components/app_dialog.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';

class EditCoursePage extends StatefulWidget {
  const EditCoursePage(this.course, {super.key});
  final CourseModel course;

  @override
  State<EditCoursePage> createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  TextEditingController nameCourseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController describeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    nameCourseController = TextEditingController(text: widget.course.name);
    categoryController = TextEditingController(text: widget.course.category);
    describeController = TextEditingController(text: widget.course.description);
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
            onTap: () => AppDialog.showModal(context,widget.course.lessons ?? []),
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
