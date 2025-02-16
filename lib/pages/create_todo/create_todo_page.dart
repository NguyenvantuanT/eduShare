import 'package:chat_app/components/app_bar/app_tab_bar_blue.dart';
import 'package:chat_app/components/app_modal.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/components/text_field/app_text_field.dart';
import 'package:chat_app/models/todo_model.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/remote/todo_services.dart';
import 'package:chat_app/utils/validator.dart';
import 'package:flutter/material.dart';

class CreateTodoPage extends StatefulWidget {
  const CreateTodoPage({super.key, this.title, this.time});

  final String? title;
  final String? time;

  @override
  State<CreateTodoPage> createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends State<CreateTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  List<Color> colors = [AppColor.blue, AppColor.pink, AppColor.orange];
  TodoServices todoServices = TodoServices();
  int selectColor = 0;
  bool isLoad = false;

  DateTime time = DateTime.now();

  void pickTime(BuildContext context) {
    AppModal.showBottomModalPickTime(context).then((value) {
      if (value == null) return;
      time = value;
      timeController.text = "${time.year}-${time.month}-${time.day}";
      setState(() {});
    });
  }

  void createTodo() {
    setState(() => isLoad = true);
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
    }).whenComplete(() => setState(() => isLoad = false));
  }

  @override
  void initState() {
    super.initState();
    if (widget.title != null) {
      titleController.text = widget.title ?? '';
    }
    if (widget.time != null) {
      timeController.text = widget.time ?? '';
    }
  }

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
          if (widget.title != null) ...[
            Text(
              'Time',
              style:
                  AppStyles.STYLE_14_BOLD.copyWith(color: AppColor.textColor),
            ),
            const SizedBox(height: 10.0),
            AppTextField(
                readOnly: true,
                controller: timeController,
                labelText: "Select time",
                validator: Validator.required,
                onTap: () => pickTime(context)),
            const SizedBox(height: 20.0),
          ],
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
                isDisable: isLoad,
                onPressed: createTodo,
              ))
        ],
      ),
    );
  }
}
