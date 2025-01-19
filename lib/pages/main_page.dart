import 'package:chat_app/components/app_tab_bar.dart';
import 'package:chat_app/pages/home/home_page.dart';
import 'package:chat_app/pages/learning/learning_page.dart';
import 'package:chat_app/pages/profile/profile_page.dart';
import 'package:chat_app/pages/search/search_page.dart';
import 'package:chat_app/resource/img/app_images.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int selectedIndex;

  List<Widget> pages = const [
    HomePage(),
    SearchPage(),
    LearningPage(),
    ProfilePage(),
  ];

  List<String> lables = [
    'Home',
    'Search',
    'Learning',
    'Favorite',
  ];

  List<String> icons = [
    AppImages.iconHome,
    AppImages.iconSearch,
    AppImages.iconBriefCase,
    AppImages.iconFavorite,
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppTabBar(
          rightPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          ),
          title: 'What do you want to learn today?',
          avatar: SharedPrefs.user?.avatar ?? '',
        ),
        body: pages[selectedIndex],
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return AnimatedContainer(
      height: 52.0,
      duration: const Duration(milliseconds: 2000),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: List.generate(
          4,
          (index) => Expanded(child: _navigationItem(index)),
        ),
      ),
    );
  }

  Widget _navigationItem(int index) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        decoration: const BoxDecoration(color: AppColor.bgColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icons[index],
              color: index == selectedIndex ? AppColor.blue : AppColor.grey,
            ),
            Text(
              lables[index],
              style: TextStyle(
                color: index == selectedIndex ? AppColor.blue : AppColor.grey,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
