import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/pages/course_detail/course_detail_page.dart';
import 'package:chat_app/pages/learning/widget/learning_item.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/course_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  CourseServices courseServices = CourseServices();
  List<CourseModel> learningList = [];

  final Stream<QuerySnapshot> courseStream = FirebaseFirestore.instance
      .collection('courses')
      .orderBy('id', descending: true)
      .snapshots();

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
            learningList = (snapshot.data?.docs
                        .map((e) => CourseModel.fromJson(
                            e.data() as Map<String, dynamic>)
                          ..docId = e.id)
                        .toList() ??
                    [])
                .where((e) =>
                    (e.learnings ?? []).contains(SharedPrefs.user?.email))
                .toList();

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                Text(
                  'Recent learning',
                  style: AppStyles.STYLE_14_BOLD
                      .copyWith(color: AppColor.textColor),
                ),
                const SizedBox(height: 10.0),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: learningList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20.0),
                  itemBuilder: (context, idx) {
                    final course = learningList[idx];
                    return LearningItem(
                      course,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseDetailPage(course.docId ?? ""),
                        ),
                      ),
                    );
                  },
                )
              ],
            );
          }),
    );
  }
}
