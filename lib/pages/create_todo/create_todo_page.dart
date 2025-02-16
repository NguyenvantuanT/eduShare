import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/models/todo_model.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';

class CreateTodoPage extends StatefulWidget {
  const CreateTodoPage({super.key, this.onCreate});

  final Function(TodoModel)? onCreate;

  @override
  State<CreateTodoPage> createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends State<CreateTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  List<Color> colors = [AppColor.blue, AppColor.pink, AppColor.orange];
  int selectColor = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: const AppTabBarBlue(title: "Add Todo"),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        children: [
          Text(
            'Title',
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
          ),
          const SizedBox(height: 10.0),
          AppTextField(
            controller: titleController,
            labelText: "Enter your title",
            textInputAction: TextInputAction.next,
            validator: Validator.required,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Note',
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
          ),
          const SizedBox(height: 10.0),
          AppTextField(
            controller: noteController,
            labelText: "Enter your note",
            textInputAction: TextInputAction.next,
            validator: Validator.required,
          ),
          const SizedBox(height: 20.0),
          Text(
            'Color',
            style: AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
          ),
          const SizedBox(height: 10.0),
          Wrap(
            children: List.generate(
                3,
                (idx) => GestureDetector(
                      onTap: () => setState(() => selectColor = idx),
                      behavior: HitTestBehavior.translucent,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: colors[idx],
                          child: selectColor == idx
                              ? const Icon(
                                  Icons.done,
                                  size: 16.0,
                                  color: AppColor.white,
                                )
                              : null,
                        ),
                      ),
                    )),
          ),
          const SizedBox(height: 20.0),
          FractionallySizedBox(
              widthFactor: 0.5,
              child: AppElevatedButton(
                text: "Create Todo",
                onPressed: () {
                  TodoModel todo = TodoModel()
                    ..title = titleController.text.trim()
                    ..note = noteController.text.trim()
                    ..color = selectColor;
                  widget.onCreate?.call(todo);
                  Navigator.pop(context);
                },
              ))
        ],
      ),
    );
  }
}
