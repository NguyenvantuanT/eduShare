import 'package:chat_app/pages/home/widgets/course_card.dart';
import 'package:chat_app/pages/home/widgets/lesson_card.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/remote/mess_services.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  MessServices messServices = MessServices();
  FocusNode messFocus = FocusNode();

  int selectIndex = 0;

  List<String> categorys = ['Recommended', 'Algebra', 'Geometry', 'Flutter'];

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
            height: 250.0,
            child: ListView.separated(
              itemCount: 5,
              padding: const EdgeInsets.only(left: 16.0),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 10.0),
              itemBuilder: (_, __) {
                return const CourseCard(
                  subject: 'Mathematics',
                  title: 'High School Algebra 1: Help and Review',
                  imageUrl: 'path_to_math_image',
                  completed: 5,
                  total: 10,
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
                    duration: const Duration(milliseconds: 1200),
                    padding: const EdgeInsets.only(
                        bottom: 10.0, left: 5.0, right: 5.0),
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
          SizedBox(
            height: 250.0,
            child: ListView.separated(
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16.0, top: 10.0),
              separatorBuilder: (_, __) => const SizedBox(width: 10.0),
              itemBuilder: (_, __) {
                return const LessonCard(
                  title: 'Bacterial Biology Overview',
                  imageUrl: 'path_to_biology_image',
                  lessonCount: 12,
                  hours: 12,
                  minutes: 20,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
