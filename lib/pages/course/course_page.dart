import 'package:chat_app/components/app_course_card.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/pages/course/edit_course_page.dart';
import 'package:chat_app/pages/course/make_course_page.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/remote/course_services.dart';
import 'package:flutter/material.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  CourseServices courseServices = CourseServices();
  List<CourseModel> courses = [];

  Future<void> getCourses() async {
    courseServices.getCourses().then((values) {
      courses = values;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
          top: MediaQuery.of(context).padding.top + 10.0,
        ),
        children: [
          Text(
            'My Course',
            style: AppStyles.STYLE_18_BOLD.copyWith(
              color: AppColor.textColor,
            ),
          ),
          const SizedBox(height: 15.0),
          ListView.separated(
            itemCount: courses.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 15.0),
            itemBuilder: (context, idx) => AppCourseCard(
              courses[idx],
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditCoursePage(courses[idx]),
              )),
            ),
          ),
        ],
      ),
      floatingActionButton: FractionallySizedBox(
        widthFactor: 0.45,
        child: AppElevatedButton(
          text: 'Make Your Course',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const MakeCoursePage()),
          ),
        ),
      ),
    );
  }
}
