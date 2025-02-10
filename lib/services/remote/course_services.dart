import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/utils/enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ImplCourseServices {
  Future<List<CourseModel>> getCourseByCategory(CategoryType category);
  Future<List<CourseModel>> getLearnings();
  Future<List<CourseModel>> getListCourse();
  Future<dynamic> deleteCourse(String docId);
  Future<CourseModel> getCourse(String docId);
  Future<dynamic> updateCourse(CourseModel course);
  Future<List<CourseModel>?> getSearchs(String query);
  Future<CourseModel> createCourse(CourseModel course);
  Future<dynamic> toggleFavorite(CourseModel course, bool isFavorite);
  Future<dynamic> toggleLearning(CourseModel course, bool isLearning);
}

class CourseServices extends ImplCourseServices {
  CollectionReference courseCollection =
      FirebaseFirestore.instance.collection('courses');
  final lessons = 'lessons';
  String email = SharedPrefs.user?.email ?? '';

  @override
  Future<List<CourseModel>> getListCourse() async {
    try {
      QuerySnapshot<Object?> data =
          await courseCollection.orderBy('id', descending: false).get();

      List<CourseModel> courses = data.docs
          .map((e) => CourseModel.fromJson(e.data() as Map<String, dynamic>)
            ..docId = e.id)
          .toList();
      return courses;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<List<CourseModel>?> getSearchs(String query) async {
    try {
      QuerySnapshot<Object?> data =
          await courseCollection.orderBy('id', descending: false).get();

      List<CourseModel> courses = data.docs
          .map((e) => CourseModel.fromJson(e.data() as Map<String, dynamic>)
            ..docId = e.id)
          .toList()
          .where(
              (e) => (e.name ?? "").toLowerCase().contains(query.toLowerCase()))
          .toList();
      return courses;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<List<CourseModel>> getLearnings() async {
    try {
      QuerySnapshot<Object?> data =
          await courseCollection.orderBy('id', descending: false).get();

      List<CourseModel> courses = data.docs
          .map((e) => CourseModel.fromJson(e.data() as Map<String, dynamic>)
            ..docId = e.id)
          .toList()
          .where((e) => (e.learnings ?? []).contains(email))
          .toList();
      return courses;
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<CourseModel> createCourse(CourseModel course) async {
    DocumentReference<Object?> doc = await courseCollection.add(
      course.toJson(),
    );
    return course..docId = doc.id;
  }

  @override
  Future<dynamic> updateCourse(CourseModel course) async {
    await courseCollection.doc(course.docId).update(course.toJson());
  }

  @override
  Future<CourseModel> getCourse(String docId) async {
    DocumentSnapshot<Object?> data = await courseCollection.doc(docId).get();
    return CourseModel.fromJson(
      data.data() as Map<String, dynamic>,
    )..docId = data.id;
  }

  @override
  Future<dynamic> deleteCourse(String docId) async {
    await courseCollection.doc(docId).delete();
  }

  @override
  Future<dynamic> toggleFavorite(CourseModel course, bool isFavorite) async {
    DocumentReference<Object?> data = courseCollection.doc(course.docId);
    const favorites = 'favorites';
    if (isFavorite) {
      await data.update({
        favorites: FieldValue.arrayUnion([email])
      });
    } else {
      await data.update({
        favorites: FieldValue.arrayRemove([email])
      });
    }
  }

  @override
  Future<dynamic> toggleLearning(CourseModel course, bool isLearning) async {
    DocumentReference<Object?> data = courseCollection.doc(course.docId);
    const learnings = 'learnings';
    if (isLearning) {
      await data.update({
        learnings: FieldValue.arrayUnion([email])
      });
    } else {
      await data.update({
        learnings: FieldValue.arrayRemove([email])
      });
    }
  }

  @override
  Future<List<CourseModel>> getCourseByCategory(CategoryType category) async {
    try {
      QuerySnapshot<Object?> data =
          await courseCollection.orderBy('id', descending: false).get();
      List<CourseModel> courses = data.docs
          .map((e) => CourseModel.fromJson(e.data() as Map<String, dynamic>)
            ..docId = e.id)
          .toList()
          .where((e) => (e.category ?? '').contains(category.name))
          .toList();
      return courses;
    } catch (e) {
      throw Exception('Error fetching courses: ${e.toString()}');
    }
  }
}
