import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/utils/validator.dart';
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

  static TextField buildTextFieldDes(TextEditingController describeController) {
    OutlineInputBorder outlineInputBorder(Color color) => OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1.2),
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        );
    return TextField(
      maxLines: 5,
      textAlign: TextAlign.start,
      controller: describeController,
      decoration: InputDecoration(
          border: outlineInputBorder(AppColor.grey),
          focusedBorder: outlineInputBorder(AppColor.grey),
          enabledBorder: outlineInputBorder(AppColor.grey),
          labelText: 'e.g., describe...',
          labelStyle: AppStyles.STYLE_14.copyWith(
            color: AppColor.textColor,
          )),
    );
  }

  static Future<LessonModel?> showModal(
      BuildContext context, List<LessonModel> lessons) async {
    final nameLessonsController = TextEditingController();
    final describeController = TextEditingController();
    final videoPathController = TextEditingController();

    return showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.67,
            child: Stack(
              children: [
                Positioned(
                  top: 0.0,
                  left: 16.0,
                  right: 16.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        color: AppColor.textColor,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 130.0, vertical: 10.0),
                        height: 3.0,
                      ),
                      Text(
                        'Name Your Lesson?',
                        style: AppStyles.STYLE_14_BOLD
                            .copyWith(color: AppColor.textColor),
                      ),
                      const SizedBox(height: 10.0),
                      AppTextField(
                        controller: nameLessonsController,
                        labelText: "e.g., lesson ...",
                        textInputAction: TextInputAction.next,
                        validator: Validator.required,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        'Description ?',
                        style: AppStyles.STYLE_14_BOLD
                            .copyWith(color: AppColor.textColor),
                      ),
                      const SizedBox(height: 10.0),
                      buildTextFieldDes(describeController),
                      const SizedBox(height: 20.0),
                      Text(
                        'Link Video?',
                        style: AppStyles.STYLE_14_BOLD
                            .copyWith(color: AppColor.textColor),
                      ),
                      const SizedBox(height: 10.0),
                      AppTextField(
                        controller: videoPathController,
                        labelText: "e.g., path ...",
                        textInputAction: TextInputAction.done,
                        validator: Validator.required,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  left: 16.0,
                  right: 16.0,
                  child: AppElevatedButton.outline(
                    text: 'Save',
                    onPressed: () => Navigator.pop(context, true),
                  ),
                )
              ],
            ),
          );
        }).then((value) {
      if (value ?? false) {
        LessonModel lesson = LessonModel()
          ..id = '${DateTime.now().millisecondsSinceEpoch}'
          ..name = nameLessonsController.text.trim()
          ..description = describeController.text.trim()
          ..videoPath = videoPathController.text.trim();
        return lesson;
      }
      return null;
    });
  }
}
