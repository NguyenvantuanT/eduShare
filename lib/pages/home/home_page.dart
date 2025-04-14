import 'package:chat_app/components/app_search_box.dart';
import 'package:chat_app/components/app_shadow.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/models/remind_model.dart';
import 'package:chat_app/pages/course_detail/course_detail_page.dart';
import 'package:chat_app/pages/home/home_vm.dart';
import 'package:chat_app/pages/home/widgets/lear_course_card.dart';
import 'package:chat_app/pages/home/widgets/course_card.dart';
import 'package:chat_app/pages/home/widgets/todo_item.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/pages/search/search_page.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

class HomePage extends StackedView<HomeVM> {
  const HomePage({super.key});

  @override
  HomeVM viewModelBuilder(BuildContext context) => HomeVM();

  @override
  void onViewModelReady(HomeVM viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.onInit();
  }

  @override
  Widget builder(BuildContext context, HomeVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: viewModel.isLoading
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
                                builder: (context) => const SearchPage(),
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
                          child: viewModel.todos.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0)
                                      .copyWith(bottom: 20.0),
                                  child: TodoItem(
                                    RemindModel()
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
                                  itemCount: viewModel.todos.length,
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0)
                                      .copyWith(bottom: 20.0),
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 8.0),
                                  itemBuilder: (context, idx) {
                                    final todo = viewModel.todos[idx];
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
                        viewModel.coursesLearning.isEmpty
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: _noLearning(context),
                              )
                            : SizedBox(
                                height: 130.0,
                                child: ListView.separated(
                                  itemCount: viewModel.coursesLearning.length,
                                  padding: const EdgeInsets.only(left: 16.0),
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 10.0),
                                  itemBuilder: (_, idx) {
                                    final course =
                                        viewModel.coursesLearning[idx];
                                    return LearCourseCard(
                                      course,
                                      onPressed: () => _navigatorDetailCourse(
                                          context,
                                          course.docId ?? '',
                                          viewModel),
                                    );
                                  },
                                ),
                              ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          height: 54.0,
                          child: _buildTabBar(viewModel),
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
                      controller: viewModel.pageController,
                      onPageChanged: viewModel.changeIndex,
                      children: [
                        RefreshIndicator(
                          onRefresh: () async {
                            viewModel.getCourseMoblie();
                          },
                          child: Center(
                            child: _buildGridVIew(
                                viewModel.coursesMoblie, viewModel),
                          ),
                        ),
                        RefreshIndicator(
                          onRefresh: () async {
                            viewModel.getCourseWeb();
                          },
                          child: Center(
                            child:
                                _buildGridVIew(viewModel.coursesWeb, viewModel),
                          ),
                        ),
                        RefreshIndicator(
                          onRefresh: () async {
                            viewModel.getCourseAI();
                          },
                          child: Center(
                            child:
                                _buildGridVIew(viewModel.coursesAI, viewModel),
                          ),
                        ),
                        RefreshIndicator(
                          onRefresh: () async {
                            viewModel.getCourseData();
                          },
                          child: Center(
                            child: _buildGridVIew(
                                viewModel.coursesData, viewModel),
                          ),
                        ),
                        RefreshIndicator(
                          onRefresh: () async {
                            viewModel.getCourseDesign();
                          },
                          child: Center(
                            child: _buildGridVIew(
                                viewModel.coursesDesign, viewModel),
                          ),
                        ),
                        RefreshIndicator(
                          onRefresh: () async {
                            viewModel.getCourseLanguage();
                          },
                          child: Center(
                            child: _buildGridVIew(
                                viewModel.coursesLanguage, viewModel),
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

  void _navigatorDetailCourse(
      BuildContext context, String? docId, HomeVM viewModel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CourseDetailPage(
          docId ?? "",
          onUpdate: () {
            viewModel.getCourseLearning();
            viewModel.getCourseMoblie();
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
        padding:
            const EdgeInsets.symmetric(horizontal: 5.0).copyWith(bottom: 5.0),
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

  GridView _buildGridVIew(List<CourseModel> list, HomeVM viewModel) {
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
                _navigatorDetailCourse(context, course.docId ?? '', viewModel));
      },
    );
  }

  Widget _buildTabBar(HomeVM viewModel) {
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
                        color: idx == viewModel.selectIndex
                            ? AppColor.blue
                            : AppColor.bgColor,
                        width: 3.0))),
            child: GestureDetector(
              onTap: () => viewModel.changeTab(idx),
              child: Text(
                CategoryType.values[idx].name,
                style: AppStyles.STYLE_14_BOLD.copyWith(
                    color: idx == viewModel.selectIndex
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
