import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/models/lesson_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ImplLessonServices {
  Future<LessonModel> getLesson(String docIdCourse, String idLesson);
  Future<List<LessonModel>> getVideos(String docIdCourse);
}

class LessonServices implements ImplLessonServices {
  CollectionReference courseCollection =
      FirebaseFirestore.instance.collection('courses');

  @override
  Future<LessonModel> getLesson(String docIdCourse, String idLesson) async {
    DocumentSnapshot<Object?> data =
        await courseCollection.doc(docIdCourse).get();
    CourseModel course =
        CourseModel.fromJson(data.data() as Map<String, dynamic>)
          ..docId = data.id;
    LessonModel? lesson = course.lessons?.firstWhere(
      (lesson) => lesson.id == idLesson,
      orElse: () => throw Exception('Lesson not found'),
    );

    return lesson ?? LessonModel();
  }

  @override
  Future<List<LessonModel>> getVideos(String docIdCourse) async {
    DocumentSnapshot<Object?> data =
        await courseCollection.doc(docIdCourse).get();
    CourseModel course =
        CourseModel.fromJson(data.data() as Map<String, dynamic>)
          ..docId = data.id;
    return course.lessons ?? [];
  }
}
