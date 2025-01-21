import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';

import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/local/shared_prefs.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  text: 'Yes',
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: AppElevatedButton(
                    height: 30,
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

  static Future<String> editInformation(
      BuildContext context, String? text, String? icon) {
    bool textEmpty = (text ?? "").isEmpty;
    final textController = TextEditingController(text: text);
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStatus) {
            return AlertDialog(
              backgroundColor: AppColor.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Align(
                  alignment: Alignment.topLeft,
                  child: SvgPicture.asset(
                    icon ?? '',
                    width: 25.0,
                    height: 25.0,
                  )),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: textController,
                    onChanged: (value) =>
                        setStatus(() => textEmpty = value.isEmpty),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppElevatedButton.small(
                        onPressed: textEmpty
                            ? null
                            : () {
                                Navigator.pop(context, true);
                              },
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        textColor: textEmpty ? AppColor.grey : AppColor.white,
                        text: 'Done',
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        }).then((value) {
      if (value ?? false) {
        return textController.text;
      } else {
        return textController.text;
      }
    });
  }

  static Future<void> confirmExitApp(BuildContext context) async {
    bool? status = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: const Text('😍'),
        content: Text(
          'Do you want to exit app?',
          style: AppStyles.STYLE_14.copyWith(color: AppColor.textColor),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppElevatedButton.small(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                text: 'Yes',
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: AppElevatedButton.small(
                  onPressed: () => Navigator.pop(context, false),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  text: 'No',
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (status == true) {
      FirebaseAuth.instance.signOut();
      SharedPrefs.removeSeason();
      SharedPrefs.setSearchText("");
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    }
  }
}
