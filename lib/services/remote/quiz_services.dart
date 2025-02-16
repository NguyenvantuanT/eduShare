import 'dart:math';

import 'package:chat_app/models/quiz_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class QuizServicesImpl {
  Future<List<QuizModel>?> getQuizs(String couseId);
  Future<QuizModel?> createQuiz(String couseId, QuizModel body);
}

class QuizServices extends QuizServicesImpl {
  CollectionReference courseCollection =
      FirebaseFirestore.instance.collection('courses');
  final quiz = 'quiz';

  @override
  Future<QuizModel?> createQuiz(String couseId, QuizModel body) async {
    DocumentReference<Map<String, dynamic>> data =
        await courseCollection.doc(couseId).collection(quiz).add(body.toJson());

    return body..quizId = data.id;
  }

  @override
  Future<List<QuizModel>> getQuizs(String couseId) async {
    QuerySnapshot<Map<String, dynamic>> data =
        await courseCollection.doc(couseId).collection(quiz).get();

    return data.docs
        .map((e) => QuizModel.fromJson(e.data())..quizId = e.id)
        .toList()..shuffle(Random());
  }
}
