import 'package:chat_app/components/app_tab_bar.dart';
import 'package:chat_app/components/app_zoom_drawer.dart';
import 'package:chat_app/pages/main/drawer_page.dart';
import 'package:chat_app/pages/main/home_page.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final zoomDrawerController = ZoomDrawerController();

  toggleDrawer() {
    zoomDrawerController.toggle?.call();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppTabBar(
          leftPressed: toggleDrawer,
          rightPressed: () {},
          title: "Home",
          avatar: SharedPrefs.user?.avatar ?? '',
        ),
        body: AppZoomDrawer(
          controller: zoomDrawerController,
          menuScreen: const DrawerPage(),
          screen: const HomePage(),
        ),
      ),
    );
  }
}
