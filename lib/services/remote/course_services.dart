import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ImplCourseServices {
  Future<List<CourseModel>> getListCourse();
  Future<CourseModel> getCourse(String docID);
  Future<CourseModel> createCourse(CourseModel course);
  Future<void> updateCourse(CourseModel course);
  Future<void> deleteCourse(String docID);
  Future<List<CourseModel>?> getSearchs(String query);
  Future<List<CourseModel>?> getLearnings(List<String> querys);
}

class CourseServices extends ImplCourseServices {
  CollectionReference courseCollection =
      FirebaseFirestore.instance.collection('courses');

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
  Future<List<CourseModel>?> getLearnings(List<String> querys) async {
    try {
      QuerySnapshot<Object?> data =
          await courseCollection.orderBy('id', descending: false).get();

      List<CourseModel> courses = data.docs
          .map((e) => CourseModel.fromJson(e.data() as Map<String, dynamic>)
            ..docId = e.id)
          .toList()
          .where((e) => querys.any((query) => (e.docId ?? "").contains(query)))
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
  Future<void> updateCourse(CourseModel course) async {
    await courseCollection.doc(course.docId).update(course.toJson());
  }

  @override
  Future<CourseModel> getCourse(String docID) async {
    DocumentSnapshot<Object?> data = await courseCollection.doc(docID).get();
    return CourseModel.fromJson(
      data.data() as Map<String, dynamic>,
    )..docId = data.id;
  }

  @override
  Future<void> deleteCourse(String docID) async {
    await courseCollection.doc(docID).delete();
  }
}
