import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/pages/course_detail/course_detail_page.dart';
import 'package:chat_app/pages/home/widgets/lear_course_card.dart';
import 'package:chat_app/pages/home/widgets/course_card.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/remote/course_services.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  List<CourseModel> coursesLearning = [];
  List<CourseModel> coursesMoblie = [];
  int selectIndex = 0;
  bool isLoading = false;

  List<String> categorys = [
    'Mobile ',
    'Web ',
    'AI',
    'Data Science and Analytics'
  ];

  void _getCourseLearning() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    courseServices.getLearnings().then((values) {
      coursesLearning = values;
      setState(() => isLoading = false);
    }).catchError((onError) {
      isLoading = false;
      setState(() {});
    });
    ;
  }

  void _getCourseMoblie() {
    courseServices.getMobile().then((values) {
      coursesMoblie = values;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _getCourseLearning();
    _getCourseMoblie();
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
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 10.0),
                  child: Text(
                    'Recent learning',
                    style: AppStyles.STYLE_14_BOLD
                        .copyWith(color: AppColor.textColor),
                  ),
                ),
                coursesLearning.isEmpty
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: _noLearning(context),
                      )
                    : SizedBox(
                        height: 180.0,
                        child: ListView.separated(
                          itemCount: coursesLearning.length,
                          padding: const EdgeInsets.only(left: 16.0),
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10.0),
                          itemBuilder: (_, idx) {
                            final course = coursesLearning[idx];
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
                  child: _buildTabBar(),
                ),
                IndexedStack(
                  index: selectIndex,
                  children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        _getCourseMoblie();
                      },
                      child: Center(
                        child: _buildGridVIew(coursesMoblie),
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        _getCourseMoblie();
                      },
                      child: Center(
                        child: _buildGridVIew(coursesLearning),
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        _getCourseMoblie();
                      },
                      child: Center(
                        child: _buildGridVIew(coursesMoblie),
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        _getCourseMoblie();
                      },
                      child: Center(
                        child: _buildGridVIew(coursesLearning),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _noLearning(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MainPage(
            index: 1,
          ),
        ),
      ),
      child: Container(
        height: 150.0,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
            color: AppColor.blue,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: AppShadow.boxShadowContainer),
        child: Column(
          children: [
            SvgPicture.asset(
              AppImages.imageOnBoarding1,
              height: 100.0,
              width: 100.0,
              fit: BoxFit.cover,
            ),
            Text(
              "Find course you want 😘",
              style: AppStyles.STYLE_14.copyWith(color: AppColor.white),
            ),
          ],
        ),
      ),
    );
  }

  GridView _buildGridVIew(List<CourseModel> list) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        childAspectRatio: 2 / 3,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
        top: 16.0,
        bottom: 20.0,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final course = list[index];
        return CourseCard(
          course,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CourseDetailPage(course.docId ?? ""),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return SingleChildScrollView(
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
    );
  }
}
