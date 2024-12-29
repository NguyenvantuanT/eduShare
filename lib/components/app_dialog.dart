import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/models/messager_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppDialog {
  AppDialog._();

  static void dialog(
    BuildContext context, {
    Widget? title,
    required String content,
    Function()? action,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  content,
                  style: const TextStyle(color: Colors.brown, fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppElevatedButton(
                  onPressed: () {
                    action?.call();
                    Navigator.pop(context);
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  text: 'Yes',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: AppElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    text: 'No',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static Future<MessagerModel> editMess(
    BuildContext context,
    MessagerModel mess,
  ) {
    final editController = TextEditingController(text: mess.text);
    bool isEmpty = (mess.text ?? "").isEmpty;
    OutlineInputBorder outlineInputBorder(Color color) => OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1.2),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        );
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (_, setStatus) {
          return AlertDialog(
            title: const Text("😘"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    maxLines: null,
                    controller: editController,
                    onChanged: (value) =>
                        setStatus(() => isEmpty = value.isEmpty),
                    decoration: InputDecoration(
                      border: outlineInputBorder(AppColor.grey),
                      focusedBorder: outlineInputBorder(AppColor.grey),
                      enabledBorder: outlineInputBorder(AppColor.blue),
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // AppElevatedButton.smallOutline(
                  //   textColor: isEmpty ? AppColor.grey : AppColor.black,
                  //   onPressed: isEmpty
                  //       ? null
                  //       : () {
                  //           Navigator.of(context).pop(true);
                  //         },
                  //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  //   text: 'Yes',
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 12.0),
                  //   child: AppElevatedButton.smallOutline(
                  //     onPressed: () => Navigator.of(context).pop(false),
                  //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  //     text: 'No',
                  //   ),
                  // ),
                ],
              ),
            ],
          );
        });
      },
    ).then((value) {
      if (value ?? false) {
        return mess..text = editController.text.trim();
      }
      return mess;
    });
  }

  static Future<void> confirmExitApp(BuildContext context) async {
    bool? status = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('😍'),
        content: const Text(
          'Do you want to exit app?',
          style: TextStyle(color: Colors.brown, fontSize: 18.0),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // AppElevatedButton.smallOutline(
              //   onPressed: () {
              //     Navigator.pop(context, true);
              //   },
              //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
              //   text: 'Yes',
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 12.0),
              //   child: AppElevatedButton.smallOutline(
              //     onPressed: () => Navigator.pop(context, false),
              //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
              //     text: 'No',
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );

    if (status == true) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }
}
