import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';

class AppShowModalBottom {
  AppShowModalBottom._();

  static Future<LessonModel?> showAllLesson(
      BuildContext context, List<LessonModel> lessons, int lessonIdx) async {
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
            heightFactor: 0.5,
            child: StatefulBuilder(builder: (context, setStatus) {
              return ListView.separated(
                itemCount: lessons.length,
                padding: const EdgeInsets.symmetric(horizontal: 16.0)
                    .copyWith(top: 30.0, bottom: 20.0),
                separatorBuilder: (_, __) => Divider(
                  color: AppColor.grey.withOpacity(0.5),
                ),
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Lesson ${index + 1}',
                          style: AppStyles.STYLE_14.copyWith(
                              color: index == lessonIdx
                                  ? AppColor.textColor
                                  : AppColor.grey,
                              fontWeight: index == lessonIdx
                                  ? FontWeight.w600
                                  : FontWeight.w400),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          lesson.name ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.STYLE_14.copyWith(
                              color: index == lessonIdx
                                  ? AppColor.textColor
                                  : AppColor.grey,
                              fontWeight: index == lessonIdx
                                  ? FontWeight.w600
                                  : FontWeight.w400),
                        ),
                        const Spacer(),
                        CircleAvatar(
                          radius: 14.0,
                          backgroundColor: index == lessonIdx
                              ? AppColor.blue
                              : AppColor.greyText,
                          child: Icon(
                            Icons.play_arrow,
                            color: index == lessonIdx
                                ? AppColor.white
                                : AppColor.grey,
                          ),
                        )
                      ]);
                },
              );
            }),
          );
        }).then((value) {
      return LessonModel();
    });
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
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        builder: (context) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0)
                .copyWith(top: 30.0, bottom: 20.0),
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
              const SizedBox(height: 30.0),
              AppElevatedButton.outline(
                text: 'Save',
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
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
