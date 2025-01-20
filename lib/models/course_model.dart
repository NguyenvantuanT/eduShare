import 'package:chat_app/models/lesson_model.dart';

class CourseModel {
  String? docId;
  String? id;
  String? name;
  String? category;
  String? description;
  String? imageCourse;
  String? createBy;
  String? progress;
  List<LessonModel>? lessons;
  List<String>? favorites;
  List<String>? learnings;

  CourseModel();

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel()
    ..id = json['id']
    ..name = json['name']
    ..category = json['category']
    ..description = json['description']
    ..imageCourse = json['imageCourse']
    ..createBy = json['createBy']
    ..progress = json['progress']
    ..lessons = (json['lessons'] as List<dynamic>)
        .map((lesson) => LessonModel.fromJson(lesson as Map<String, dynamic>))
        .toList()
    ..learnings =
        json['learnings'] != null ? List<String>.from(json['learnings']) : null
    ..favorites =
        json['favorites'] != null ? List<String>.from(json['favorites']) : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'imageCourse': imageCourse,
      'createBy': createBy,
      'progress': progress,
      'lessons': lessons?.map((lesson) => lesson.toJson()),
      'learnings': learnings?.map((e) => e).toList(),
      'favorites': favorites?.map((e) => e).toList(),
    };
  }
}
