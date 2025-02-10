import 'package:chat_app/models/lesson_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ImplLessonServices {
  Future<LessonModel> getLesson(String docIdCourse, String lessonId);
  Future<dynamic> createLesson(String docIdCourse, LessonModel lesson);
  Future<List<LessonModel>> getLessons(String docIdCourse);
  Future<dynamic> updateLesson(String docIdCourse, LessonModel lesson);
  Future<dynamic> deleteLesson(String docIdCourse, String lessonId);
}

class LessonServices implements ImplLessonServices {
  CollectionReference courseCollection =
      FirebaseFirestore.instance.collection('courses');
  final lessons = 'lessons';

  @override
  Future<LessonModel> getLesson(String docIdCourse, String lessonId) async {
    DocumentSnapshot<Object?> data = await courseCollection
        .doc(docIdCourse)
        .collection(lessons)
        .doc(lessonId)
        .get();
    LessonModel lesson =
        LessonModel.fromJson(data.data() as Map<String, dynamic>)
          ..lessonId = data.id;
    return lesson;
  }

  @override
  Future<List<LessonModel>> getLessons(String docIdCourse) async {
    QuerySnapshot<Map<String, dynamic>> datas =
        await courseCollection.doc(docIdCourse).collection(lessons).get();

    final values = datas.docs
        .map((e) => LessonModel.fromJson(e.data())..lessonId = e.id)
        .toList();
    return values;
  }

  @override
  Future<dynamic> createLesson(String docIdCourse, LessonModel lesson) async {
    try {
      DocumentReference<Map<String, dynamic>> doc = await courseCollection
          .doc(docIdCourse)
          .collection(lessons)
          .add(lesson.toJson());

      return lesson..lessonId = doc.id;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<dynamic> updateLesson(String docIdCourse, LessonModel lesson) async {
    try {
      await courseCollection
          .doc(docIdCourse)
          .collection(lessons)
          .doc(lesson.lessonId)
          .update(lesson.toJson());
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<dynamic> deleteLesson(String docIdCourse, String lessonId) async {
    try {
      await courseCollection
          .doc(docIdCourse)
          .collection(lessons)
          .doc(lessonId)
          .delete();
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }
}
