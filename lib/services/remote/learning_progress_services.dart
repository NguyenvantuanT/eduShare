import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LearningProgressServicesImpl {
  Future<LearningProgressModel?> getLessonProgress({
    String? docIdCourse,
    String? lessonId,
  });
  Future<dynamic> createLessonProgress({
    String? docIdCourse,
    String? lessonId,
    required LearningProgressModel value,
  });
  Future<dynamic> updateLessonProgress({
    String? docIdCourse,
    String? lessonId,
    required LearningProgressModel value,
  });
}

class LearningProgressServices extends LearningProgressServicesImpl {
  CollectionReference courseCollection =
      FirebaseFirestore.instance.collection('courses');

  final lessons = 'lessons';
  final progress = 'Progress';
  final email = SharedPrefs.user?.email;

  @override
  Future<LearningProgressModel?> getLessonProgress({
    String? docIdCourse,
    String? lessonId,
  }) async {
    try {
      DocumentSnapshot<Object?> data = await courseCollection
          .doc(docIdCourse)
          .collection(lessons)
          .doc(lessonId)
          .collection(progress)
          .doc(email)
          .get();

      if (data.exists && data.data() != null) {
        return LearningProgressModel.fromJson(
            data.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<dynamic> createLessonProgress({
    String? docIdCourse,
    String? lessonId,
    required LearningProgressModel value,
  }) async {
    try {
      await courseCollection
          .doc(docIdCourse)
          .collection(lessons)
          .doc(lessonId)
          .collection(progress)
          .doc(email)
          .set(value.toJson());
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<dynamic> updateLessonProgress({
    String? docIdCourse,
    String? lessonId,
    required LearningProgressModel value,
  }) async {
    await courseCollection
          .doc(docIdCourse)
          .collection(lessons)
          .doc(lessonId)
          .collection(progress)
          .doc(email)
          .update(value.toJson());
  }
}
