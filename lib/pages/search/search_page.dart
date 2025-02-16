import 'package:chat_app/components/app_bar/app_tab_bar.dart';
import 'package:chat_app/components/app_search_box.dart';
import 'package:chat_app/pages/course_detail/course_detail_page.dart';
import 'package:chat_app/pages/profile/profile_page.dart';
import 'package:chat_app/pages/search/search_vm.dart';
import 'package:chat_app/pages/search/widgets/create_course_item.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

class SearchPage extends StackedView<SearchVM> {
  const SearchPage({super.key});

  @override
  void onViewModelReady(SearchVM viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.onInit();
  }

  @override
  SearchVM viewModelBuilder(BuildContext context) => SearchVM();

  @override
  Widget builder(BuildContext context, SearchVM viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: AppTabBar(
        rightPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        ),
        title: 'What do you want to learn today?',
        avatar: SharedPrefs.user?.avatar ?? '',
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          SizedBox(
            height: 51.0,
            child: AppSearchBox(
              onChanged: (value) {
                viewModel.searchCourse(value);
                SharedPrefs.setSearchText(value);
              },
              searchController: viewModel.searchController,
              searchFocus: viewModel.searchFocus,
            ),
          ),
          viewModel.searchList.isEmpty
              ? Column(
                  children: [
                    const SizedBox(height: 160.0),
                    GestureDetector(
                        onTap: () => viewModel.searchFocus.requestFocus(),
                        child: SvgPicture.asset(
                          AppImages.iconSearch,
                          color: AppColor.blue,
                          fit: BoxFit.cover,
                        )),
                    const SizedBox(height: 6.0),
                    Text(
                      'Search The Course',
                      style: AppStyles.STYLE_18.copyWith(
                        color: AppColor.textColor,
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: viewModel.searchList.length,
                  separatorBuilder: (_, __) => const SizedBox(),
                  itemBuilder: (context, idx) {
                    final course = viewModel.searchList[idx];
                    return CourseSearchItem(
                      course,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CourseDetailPage(
                            course.docId ?? "",
                          ),
                        ),
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }
}

