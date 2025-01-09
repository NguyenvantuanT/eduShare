import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/pages/course_detail/course_detail_page.dart';
import 'package:chat_app/pages/home/widgets/lear_course_card.dart';
import 'package:chat_app/pages/home/widgets/course_card.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/remote/course_services.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:flutter/material.dart';
// ignore_for_file: constant_identifier_names

enum Category {
  Mobile,
  Web,
  AI,
  Data,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  FocusNode messFocus = FocusNode();
  CourseServices courseServices = CourseServices();
  List<CourseModel> courses = [];
  int selectIndex = 0;

  List<String> categorys = [
    'Mobile Application',
    'Web Development',
    'Artificial Intelligence',
    'Data Science and Analytics'
  ];

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
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 10.0),
            child: Text(
              'Recent learning',
              style:
                  AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
            ),
          ),
          SizedBox(
            height: 180.0,
            child: ListView.separated(
              itemCount: courses.length,
              padding: const EdgeInsets.only(left: 16.0),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 10.0),
              itemBuilder: (_, idx) {
                final course = courses[idx];
                return LearCourseCard(
                  course,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CourseDetailPage(course.docId ?? ""),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            height: 54.0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(categorys.length, (idx) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ).copyWith(bottom: 6.0),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                        color: AppColor.bgColor,
                        border: Border(
                            bottom: BorderSide(
                                color: idx == selectIndex
                                    ? AppColor.blue
                                    : AppColor.bgColor,
                                width: 3.0))),
                    child: GestureDetector(
                      onTap: () => setState(() => selectIndex = idx),
                      child: Text(
                        categorys[idx],
                        style: AppStyles.STYLE_14_BOLD.copyWith(
                            color: idx == selectIndex
                                ? AppColor.textColor
                                : AppColor.greyText),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 2 / 3,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
              top: 16.0,
              bottom: 20.0,
            ),
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return CourseCard(
                course,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CourseDetailPage(course.docId ?? ""),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
