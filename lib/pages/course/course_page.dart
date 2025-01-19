import 'package:chat_app/components/app_course_card.dart';
import 'package:chat_app/components/app_dialog.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/pages/course/edit_course_page.dart';
import 'package:chat_app/pages/course/make_course_page.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/course_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyCoursePage extends StatefulWidget {
  const MyCoursePage({super.key});

  @override
  State<MyCoursePage> createState() => _MyCoursePageState();
}

class _MyCoursePageState extends State<MyCoursePage> {
  CourseServices courseServices = CourseServices();
  List<CourseModel> courses = [];
  String email = SharedPrefs.user?.email ?? "";

  final Stream<QuerySnapshot> courseStream = FirebaseFirestore.instance
      .collection('courses')
      .orderBy('id', descending: true)
      .snapshots();

  void deleteCourse(BuildContext context, String docId) {
    AppDialog.dialog(
      context,
      title: const Icon(Icons.delete, color: AppColor.blue,),
      content: "Do you want delete this course ? 😢",
      action: () => courseServices.deleteCourse(docId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: StreamBuilder(
          stream: courseStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColor.blue),
              );
            }

            List<CourseModel> courses = (snapshot.data?.docs
                        .map((e) => CourseModel.fromJson(
                            (e.data() as Map<String, dynamic>))
                          ..docId = e.id)
                        .toList() ??
                    [])
                .where((e) => e.createBy == email)
                .toList();

            return ListView(
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
                    itemBuilder: (context, idx) {
                      final course = courses.reversed.toList()[idx];
                      return AppCourseCard(
                        course,
                        onLeftPressed: () => deleteCourse(context, course.docId ?? ""),
                        onRigthPressed: () => Navigator.of(context).push( MaterialPageRoute(
                            builder: (context) => EditCoursePage(
                              course.docId ?? "",
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            );
          }),
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
