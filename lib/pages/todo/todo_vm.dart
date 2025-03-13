import 'package:chat_app/models/todo_model.dart';
import 'package:chat_app/services/remote/todo_services.dart';
import 'package:stacked/stacked.dart';

class TodoVM extends BaseViewModel{
  final now = DateTime.now();
  DateTime selectDate = DateTime.now();
  TodoServices todoServices = TodoServices();
  List<TodoModel> todos = [];

  void onInit() {
    getTodoList();
  }

  void getTodoList() {
    todoServices.getTodos().then((values) {
      todos = values ?? [];
      rebuildUi();
    });
  }

  void getTodosByDate(DateTime dateTime) {
    String path = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
    todoServices.getTodosByDate(path).then((values) {
      todos = values;
      rebuildUi();
    });
  }

  void deleteTodo(String todoId) {
    todoServices.deleteTodo(todoId).then((_) {
      todos.removeWhere((e) => e.todoId == todoId);
      rebuildUi();
    });
  }

  void updateTodo(TodoModel todo) {
    todo.isCompleted = true;
    todoServices.updateTodo(todo).then((_) {
      todos.singleWhere((e) => e.todoId == todo.todoId)
        ..title = todo.title
        ..note = todo.note
        ..isCompleted = todo.isCompleted;
      rebuildUi();
    });
  }

  
}