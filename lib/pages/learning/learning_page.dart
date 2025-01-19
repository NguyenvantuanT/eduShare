import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/pages/learning/widget/course_learning_item.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/course_services.dart';
import 'package:flutter/material.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  CourseServices courseServices = CourseServices();
  List<CourseModel> learningList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getLearnings();
  }

  void getLearnings() async {
    setState(() => isLoading = true);
    courseServices
        .getLearnings(SharedPrefs.user?.learnings ?? [])
        .then((values) {
      learningList = values ?? [];
      setState(() {});
    }).whenComplete(() => setState(() => isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColor.blue),
            )
          : ListView(
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
                  separatorBuilder: (_, __) => const SizedBox(),
                  itemBuilder: (context, idx) {
                    final course = learningList[idx];
                    return CourseLearningItem(course);
                  },
                )
              ],
            ),
    );
  }
}
