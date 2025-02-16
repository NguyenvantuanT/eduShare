import 'package:chat_app/components/app_modal.dart';
import 'package:chat_app/components/button/app_elevated_button.dart';
import 'package:chat_app/models/todo_model.dart';
import 'package:chat_app/pages/create_todo/create_todo_page.dart';
import 'package:chat_app/pages/todo/widgets/todo_card.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/resource/themes/app_style.dart';
import 'package:chat_app/services/remote/todo_services.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final now = DateTime.now();
  DateTime selectDate = DateTime.now();
  TodoServices todoServices = TodoServices();
  List<TodoModel> todos = [];

  @override
  void initState() {
    super.initState();
    getTodoList();
  }

  void getTodoList() {
    todoServices.getTodos().then((values) {
      todos = values ?? [];
      setState(() {});
    });
  }

  void getTodosByDate(String path) {
    todoServices.getTodosByDate(path).then((values) {
      todos = values;
      setState(() {});
    });
  }

  void deleteTodo(String todoId) {
    todoServices.deleteTodo(todoId).then((_) {
      todos.removeWhere((e) => e.todoId == todoId);
      setState(() {});
    });
  }

  void updateTodo(TodoModel todo) {
    todo.isCompleted = true;
    todoServices.updateTodo(todo).then((_) {
      todos.singleWhere((e) => e.todoId == todo.todoId)
        ..title = todo.title
        ..note = todo.note
        ..isCompleted = todo.isCompleted;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildAddTodo(),
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0).copyWith(left: 16.0),
            child: DatePicker(
              now,
              height: 90.0,
              width: 60.0,
              initialSelectedDate: now,
              selectionColor: AppColor.blue,
              selectedTextColor: AppColor.bgColor,
              dateTextStyle:
                  AppStyles.STYLE_14.copyWith(color: AppColor.textColor),
              monthTextStyle:
                  AppStyles.STYLE_12.copyWith(color: AppColor.textColor),
              onDateChange: (date) {
                selectDate = date;
                String path =
                    "${selectDate.year}-${selectDate.month}-${selectDate.day}";
                getTodosByDate(path);
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: todos.length,
              padding: const EdgeInsets.symmetric(horizontal: 16.0)
                  .copyWith(bottom: 20.0),
              separatorBuilder: (_, __) => const SizedBox(height: 10.0),
              itemBuilder: (context, idx) {
                final todo = todos[idx];
                return AnimationConfiguration.staggeredList(
                  position: idx,
                  child: SlideAnimation(
                    duration: const Duration(milliseconds: 500),
                    horizontalOffset: 200.0,
                    child: FadeInAnimation(
                        child: TodoCard(
                      todo,
                      onTap: () {
                        AppModal.todoModal(
                          context,
                          onDelete: () => deleteTodo(todo.todoId ?? ""),
                          onComplete: () => updateTodo(todo),
                        );
                      },
                    )),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddTodo() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: AppStyles.STYLE_14_BOLD.copyWith(
                  color: AppColor.textColor,
                ),
              ),
              Text(
                "Today",
                style: AppStyles.STYLE_14_BOLD.copyWith(
                  color: AppColor.textColor,
                ),
              )
            ],
          ),
        ),
        AppElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateTodoPage(),
            ),
          ),
          height: 40,
          icon: const Icon(
            Icons.add,
            color: AppColor.white,
            size: 12.0,
          ),
          text: "Add Todo",
        )
      ],
    );
  }
}
