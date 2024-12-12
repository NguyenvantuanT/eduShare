import 'dart:developer' as dev;
import 'package:chat_app/models/messager_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ImplMessServices {
  void addMess(MessagerModel mess);
  void deleteMes(String docId);
  void updateMess(MessagerModel mess);
}

class MessServices implements ImplMessServices {
  CollectionReference databaseCollection =
      FirebaseFirestore.instance.collection('database');

  @override
  void addMess(MessagerModel mess) {
    databaseCollection
        .add(mess.toJson())
        .then((value) => dev.log("Mess Added $value"))
        .catchError((error) => dev.log("Failed to add Mess: $error"));
  }

  @override
  void deleteMes(String docId) {
    databaseCollection
        .doc(docId)
        .delete()
        .then((val) => dev.log("Mess Deleted"))
        .catchError((error) => dev.log("Failed to delete Mess: $error"));
  }

  @override
  void updateMess(MessagerModel mess) {
     databaseCollection
        .doc(mess.docId)
        .update(mess.toJson())
        .then((value) => dev.log("Mess Updated"))
        .catchError((error) => dev.log("Failed to update Mess: $error"));
  }


}
