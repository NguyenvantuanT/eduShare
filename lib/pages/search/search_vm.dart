import 'package:chat_app/components/debouncer.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/course_services.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SearchVM extends BaseViewModel{

  TextEditingController searchController = TextEditingController();
  CourseServices courseServices = CourseServices();
  Debouncer debouncer = Debouncer(milliseconds: 500);
  FocusNode searchFocus = FocusNode();
  List<CourseModel> searchList = [];

  void onInit() {
    getSearchText();
  }

  void getSearchText() {
    SharedPrefs.getSearchText().then((value) {
      searchController.text = value ?? '';
      searchCourse(value ?? '');
    });
  }

  void searchCourse(String query) {
    debouncer.run(() async {
      if (query.isEmpty) {
        searchList = [];
        rebuildUi();
      } else {
        await courseServices.getSearchs(query).then((value) {
          searchList = value ?? [];
          rebuildUi();
        }).catchError((onError) {});
      }
    });
  }
}