import 'package:chat_app/components/app_modal.dart';
import 'package:chat_app/models/remind_model.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/services/remote/todo_services.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateRemindVM extends BaseViewModel {
  CreateRemindVM({this.title, this.timeSt});
  final String? title;
  final String? timeSt;

  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  List<Color> colors = [AppColor.blue, AppColor.pink, AppColor.orange];
  RemindServices todoServices = RemindServices();
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
    RemindModel todo = RemindModel()
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

  Future<void> shareViaEmail(BuildContext context) async {
    final subject = Uri.encodeComponent(titleController.text.isEmpty
        ? 'My Reminder Note'
        : titleController.text);
    final body = Uri.encodeComponent('Note: ${noteController.text}\n'
        '${timeController.text.isEmpty ? '' : 'Time: ${timeController.text}'}');
    final uri = Uri.parse('mailto:?subject=$subject&body=$body');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> shareToFacebook(BuildContext context) async {
    try {
      final content = 'Note: ${noteController.text}\n'
          '${timeController.text.isEmpty ? '' : 'Time: ${timeController.text}'}';
      await Share.share(
        content,
        subject: titleController.text.isEmpty
            ? 'My Reminder Note'
            : titleController.text,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
