import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ImplCourseServices {
  Future<List<CourseModel>> getCourses();
  Future<CourseModel> getCourse(String docID);
  Future<CourseModel> createCourse(CourseModel course);
  Future<void> updateCourse(CourseModel course);
}

class CourseServices extends ImplCourseServices {
  CollectionReference courseCollection =
      FirebaseFirestore.instance.collection('courses');

  String email = SharedPrefs.user?.email ?? '';

  @override
  Future<List<CourseModel>> getCourses() async {
    QuerySnapshot<Object?> data =
        await courseCollection.orderBy('id', descending: false).get();

    List<CourseModel> courses = data.docs
        .map((e) => CourseModel.fromJson(e.data() as Map<String, dynamic>)
          ..docId = e.id)
        .toList();
    return courses;
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
}
