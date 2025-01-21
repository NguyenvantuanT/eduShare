import 'package:chat_app/components/app_bar/app_tab_bar.dart';
import 'package:chat_app/components/app_search_box.dart';
import 'package:chat_app/components/debouncer.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/pages/course_detail/course_detail_page.dart';
import 'package:chat_app/pages/profile/profile_page.dart';
import 'package:chat_app/pages/search/widgets/create_course_item.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/course_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.onUpdate});

  final Function()? onUpdate;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  CourseServices courseServices = CourseServices();
  Debouncer debouncer = Debouncer(milliseconds: 500);
  FocusNode searchFocus = FocusNode();
  List<CourseModel> searchList = [];

  @override
  void initState() {
    super.initState();
    _getSearchText();
  }

  void _getSearchText() {
    SharedPrefs.getSearchText().then((value) {
      searchController.text = value ?? '';
      _searchCourse(value ?? '');
    });
  }

  void _searchCourse(String query) {
    debouncer.run(() async {
      if (query.isEmpty) {
        searchList = [];
        setState(() {});
      } else {
        await courseServices.getSearchs(query).then((value) {
          searchList = value ?? [];
          setState(() {});
        }).catchError((onError) {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                _searchCourse(value);
                SharedPrefs.setSearchText(value);
              },
              searchController: searchController,
              searchFocus: searchFocus,
            ),
          ),
          searchList.isEmpty
              ? Column(
                  children: [
                    const SizedBox(height: 160.0),
                    GestureDetector(
                        onTap: () => searchFocus.requestFocus(),
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
                  itemCount: searchList.length,
                  separatorBuilder: (_, __) => const SizedBox(),
                  itemBuilder: (context, idx) {
                    final course = searchList[idx];
                    return CourseSearchItem(
                      course,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => CourseDetailPage(
                                  course.docId ?? "",
                                  onUpdate: () => widget.onUpdate?.call(),
                                )),
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }
}
