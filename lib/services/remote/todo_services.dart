import 'package:chat_app/models/remind_model.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RemindServicesImpl {
  Future<List<RemindModel>?> getTodos();
  Future<List<RemindModel>> getTodosByDate(String date);
  Future<RemindModel> createTodo(RemindModel todo);
  Future<dynamic> deleteTodo(String todoId);
  Future<dynamic> updateTodo(RemindModel todo);
}

class RemindServices extends RemindServicesImpl {
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final todoCollection = 'todos';
  String email = SharedPrefs.user?.email ?? '';

  @override
 Future<List<RemindModel>?> getTodos() async {
    QuerySnapshot<Map<String, dynamic>> datas =
        await userCollection.doc(email).collection(todoCollection).get();
    
    List<RemindModel> todos = datas.docs
        .map((e) => RemindModel.fromJson(e.data())..todoId = e.id)
        .toList();
        
    return todos.isEmpty ? null : todos;
}

  @override
  Future<RemindModel> createTodo(RemindModel todo) async {
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
  Future<List<RemindModel>> getTodosByDate(String date) async {
    QuerySnapshot<Map<String, dynamic>> datas =
        await userCollection.doc(email).collection(todoCollection).get();

    return datas.docs
        .map((e) => RemindModel.fromJson(e.data())..todoId = e.id)
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
  Future<dynamic> updateTodo(RemindModel todo) async {
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
