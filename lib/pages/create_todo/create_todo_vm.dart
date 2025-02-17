import 'package:chat_app/components/app_modal.dart';
import 'package:chat_app/models/todo_model.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/services/remote/todo_services.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CreateTodoVM extends BaseViewModel{
  CreateTodoVM({this.title,this.timeSt});
  final String? title;
  final String? timeSt;

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  List<Color> colors = [AppColor.blue, AppColor.pink, AppColor.orange];
  TodoServices todoServices = TodoServices();
  int selectColor = 0;
  bool isLoad = false;

  DateTime time = DateTime.now();

  void onInit() {
    if (title != null) {
      titleController.text = title ?? '';
    }
    if (timeSt != null) {
      timeController.text = timeSt ?? '';
    }
  }

  void changeColor(int idx) {
    selectColor = idx;
    rebuildUi();
  }

  void pickTime(BuildContext context) {
    AppModal.showBottomModalPickTime(context).then((value) {
      if (value == null) return;
      time = value;
      timeController.text = "${time.year}-${time.month}-${time.day}";
      rebuildUi();
    });
  }

  void createTodo(BuildContext context) {
    isLoad = true;
    rebuildUi();
    TodoModel todo = TodoModel()
      ..color = selectColor
      ..dateCreate = timeController.text
      ..isCompleted = false
      ..note = noteController.text.trim()
      ..title = titleController.text.trim();
    todoServices.createTodo(todo).then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainPage(index: 1),
            ),
            (Route<dynamic> route) => false);
      });
    }).whenComplete(() {
      isLoad = false;
      rebuildUi();
    });
  }
}