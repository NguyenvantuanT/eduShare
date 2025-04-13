import 'dart:math';

import 'package:chat_app/models/quiz_model.dart';
import 'package:chat_app/utils/enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class QuizServicesImpl {
  Future<List<QuizModel>?> getQuizs(String couseId);
  Future<QuizModel?> createQuiz(String couseId, QuizModel body);
  Future<QuizModel> updateQuiz(String courseId, QuizModel body);
  Future<List<QuizModel>?> getQuizzesByDifficulty(String courseId,
      {DifficultyLevel? level});
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
  Future<List<QuizModel>?> getQuizs(String couseId,
      {DifficultyLevel? level}) async {
    QuerySnapshot<Map<String, dynamic>> data =
        await courseCollection.doc(couseId).collection(quiz).get();

    return data.docs
        .map((e) => QuizModel.fromJson(e.data())..quizId = e.id)
        .toList()
      ..shuffle(Random());
  }

  @override
  Future<QuizModel> updateQuiz(String courseId, QuizModel body) async {
    try {
      await courseCollection
          .doc(courseId)
          .collection(quiz)
          .doc(body.quizId)
          .update(body.toJson());

      return body;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<List<QuizModel>?> getQuizzesByDifficulty(String courseId,
      {DifficultyLevel? level}) async {
    QuerySnapshot<Map<String, dynamic>> data =
        await courseCollection.doc(courseId).collection(quiz).get();

    return data.docs
        .map((e) => QuizModel.fromJson(e.data())..quizId = e.id)
        .where((e) => e.difficulty == level)
        .toList()
      ..shuffle(Random());
  }
}
