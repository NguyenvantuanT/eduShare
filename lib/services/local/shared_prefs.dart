import 'dart:convert';

import 'package:chat_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String checkAccess = 'checkAccess';
  static const String userKey = 'user';
  static const String searchKey = 'search';

  static late SharedPreferences _prefs;

  static Future<void> initialise() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<String?> getSearchText() async {
    return _prefs.getString(searchKey);
  }

  static Future<void> setSearchText(String searchText) async {
    _prefs.setString(searchKey, searchText);
  }


  static bool get isLogin {
    String? data = _prefs.getString(userKey);
    if(data == null) return false;
    return true;
  } 

  static bool get isAccessed => _prefs.getBool(checkAccess) ?? false;

  static set isAccessed(bool access) =>  _prefs.setBool(checkAccess, access);

  static UserModel? get user {
    String? data = _prefs.getString(userKey);
    if (data == null) return null;
    return UserModel.fromJson(jsonDecode(data));
  }

  static set user(UserModel? user) {
    _prefs.setString(userKey, jsonEncode(user?.toJson()));
  }

  static removeSeason() {
    _prefs.remove(userKey);
  }
}
