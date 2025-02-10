import 'package:chat_app/models/todo_model.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class TodoServicesImpl {
  Future<List<TodoModel>?> getTodos();
  Future<List<TodoModel>> getTodosByDate(String date);
  Future<TodoModel> createTodo(TodoModel todo);
  Future<dynamic> deleteTodo(String todoId);
  Future<dynamic> updateTodo(TodoModel todo);
}

class TodoServices extends TodoServicesImpl {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final todoCollection = 'todos';
  String email = SharedPrefs.user?.email ?? '';

  @override
 Future<List<TodoModel>?> getTodos() async {
    QuerySnapshot<Map<String, dynamic>> datas =
        await userCollection.doc(email).collection(todoCollection).get();
    
    List<TodoModel> todos = datas.docs
        .map((e) => TodoModel.fromJson(e.data())..todoId = e.id)
        .toList();
        
    return todos.isEmpty ? null : todos;
}

  @override
  Future<TodoModel> createTodo(TodoModel todo) async {
    try {
      DocumentReference<Map<String, dynamic>> data = await userCollection
          .doc(email)
          .collection(todoCollection)
          .add(todo.toJson());
      return todo..todoId = data.id;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<List<TodoModel>> getTodosByDate(String date) async {
    QuerySnapshot<Map<String, dynamic>> datas =
        await userCollection.doc(email).collection(todoCollection).get();

    return datas.docs
        .map((e) => TodoModel.fromJson(e.data())..todoId = e.id)
        .toList()
        .where((todo) => todo.dateCreate == date)
        .toList();
  }

  @override
  Future<dynamic> deleteTodo(String todoId) async {
    await userCollection
        .doc(email)
        .collection(todoCollection)
        .doc(todoId)
        .delete();
  }

  @override
  Future<dynamic> updateTodo(TodoModel todo) async {
    try {
      await userCollection
          .doc(email)
          .collection(todoCollection)
          .doc(todo.todoId)
          .update(todo.toJson());
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }
}
