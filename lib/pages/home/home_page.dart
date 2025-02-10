import 'package:chat_app/components/app_search_box.dart';
import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/models/todo_model.dart';
import 'package:chat_app/pages/course_detail/course_detail_page.dart';
import 'package:chat_app/pages/home/widgets/lear_course_card.dart';
import 'package:chat_app/pages/home/widgets/course_card.dart';
import 'package:chat_app/pages/home/widgets/todo_item.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/pages/search/search_page.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/remote/course_services.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/services/remote/todo_services.dart';
import 'package:chat_app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final messageController = TextEditingController();
  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();
  FocusNode messFocus = FocusNode();
  CourseServices courseServices = CourseServices();
  TodoServices todoServices = TodoServices();
  List<CourseModel> coursesLearning = [];
  List<CourseModel> coursesMoblie = [];
  List<CourseModel> coursesWeb = [];
  List<CourseModel> coursesAI = [];
  List<CourseModel> coursesData = [];
  List<CourseModel> coursesDesign = [];
  List<CourseModel> coursesLanguage = [];
  List<TodoModel> todos = [];
  int selectIndex = 0;
  bool isLoading = false;

  void _getCourseLearning() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    courseServices.getLearnings().then((values) {
      setState(() {
        coursesLearning = values;
        isLoading = false;
      });
    }).catchError((onError) {
      isLoading = false;
      setState(() {});
    });
  }

  void _getCourseMoblie() {
    courseServices.getCourseByCategory(CategoryType.Mobile).then((values) {
      coursesMoblie = values;
      setState(() {});
    });
  }

  void _getCourseWeb() {
    courseServices.getCourseByCategory(CategoryType.Web).then((values) {
      coursesWeb = values;
      setState(() {});
    });
  }

  void _getCourseAI() {
    courseServices.getCourseByCategory(CategoryType.AI).then((values) {
      coursesAI = values;
      setState(() {});
    });
  }

  void _getCourseData() {
    courseServices.getCourseByCategory(CategoryType.Data).then((values) {
      coursesData = values;
      setState(() {});
    });
  }

  void _getCourseDesign() {
    courseServices.getCourseByCategory(CategoryType.Design).then((values) {
      coursesDesign = values;
      setState(() {});
    });
  }

  void _getCourseLanguage() {
    courseServices.getCourseByCategory(CategoryType.Language).then((values) {
      coursesLanguage = values;
      setState(() {});
    });
  }

  void getTodos() {
    todoServices.getTodos().then((values) {
      todos = values ?? [];
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getTodos();
    _getCourseLearning();
    _getCourseMoblie();
    _getCourseWeb();
    _getCourseAI();
    _getCourseData();
    _getCourseDesign();
    _getCourseLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColor.blue),
            )
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0)
                              .copyWith(bottom: 10.0),
                          child: AppSearchBox(
                            readOnly: true,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SearchPage(
                                  onUpdate: _getCourseLearning,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, bottom: 10.0),
                          child: Text(
                            'Todo Task',
                            style: AppStyles.STYLE_14_BOLD
                                .copyWith(color: AppColor.textColor),
                          ),
                        ),
                        SizedBox(
                          height: 120.0,
                          child: todos.isEmpty
                              ? Padding(
                                 padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0)
                                      .copyWith(bottom: 20.0),
                                child: TodoItem(
                                    TodoModel()
                                      ..color = 0
                                      ..title = "Make your Todo"
                                      ..note = "Tap to create",
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MainPage(index: 1))),
                                  ),
                              )
                              : ListView.separated(
                                  itemCount: todos.length,
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0)
                                      .copyWith(bottom: 20.0),
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 8.0),
                                  itemBuilder: (context, idx) {
                                    final todo = todos[idx];
                                    return AnimationConfiguration.staggeredList(
                                      position: idx,
                                      child: SlideAnimation(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        horizontalOffset: 200.0,
                                        child: FadeInAnimation(
                                            child: TodoItem(
                                          todo,
                                        )),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, bottom: 10.0),
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
                                height: 130.0,
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
                                      onPressed: () => _navigatorDetailCourse(
                                          context, course.docId ?? ''),
                                    );
                                  },
                                ),
                              ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          height: 54.0,
                          child: _buildTabBar(),
                        ),
                      ],
                    ),
                  )
                ];
              },
              body: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      onPageChanged: (int index) {
                        setState(() => selectIndex = index);
                      },
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
                            _getCourseWeb();
                          },
                          child: Center(
                            child: _buildGridVIew(coursesWeb),
                          ),
                        ),
                        RefreshIndicator(
                          onRefresh: () async {
                            _getCourseAI();
                          },
                          child: Center(
                            child: _buildGridVIew(coursesAI),
                          ),
                        ),
                        RefreshIndicator(
                          onRefresh: () async {
                            _getCourseData();
                          },
                          child: Center(
                            child: _buildGridVIew(coursesData),
                          ),
                        ),
                        RefreshIndicator(
                          onRefresh: () async {
                            _getCourseDesign();
                          },
                          child: Center(
                            child: _buildGridVIew(coursesDesign),
                          ),
                        ),
                        RefreshIndicator(
                          onRefresh: () async {
                            _getCourseLanguage();
                          },
                          child: Center(
                            child: _buildGridVIew(coursesLanguage),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _navigatorDetailCourse(BuildContext context, String? docId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CourseDetailPage(
          docId ?? "",
          onUpdate: () {
            _getCourseLearning();
            _getCourseMoblie();
          },
        ),
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
        height: 120.0,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 5.0).copyWith(bottom : 5.0),
        decoration: BoxDecoration(
            color: AppColor.blue,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: AppShadow.boxShadowContainer),
        child: Column(
          children: [
            SvgPicture.asset(
              AppImages.imageOnBoarding1,
              height: 90.0,
              width: 90.0,
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
        return CourseCard(course,
            onPressed: () =>
                _navigatorDetailCourse(context, course.docId ?? ''));
      },
    );
  }

  Widget _buildTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(CategoryType.values.length, (idx) {
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
              onTap: () {
                selectIndex = idx;
                pageController.jumpToPage(selectIndex);
              },
              child: Text(
                CategoryType.values[idx].name,
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
