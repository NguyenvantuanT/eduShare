import 'package:chat_app/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MainVM extends BaseViewModel {
  MainVM({this.index});

  final int? index;
  late int selectedIndex;

  void onInit() {
    selectedIndex = index ?? 0;
  }

  void navigatorToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  void changePage(int index) {
    selectedIndex = index;
    rebuildUi();
  }
}
