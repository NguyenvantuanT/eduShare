class CourseModel {
  String? docId;
  String? id;
  String? name;
  String? category;
  String? description;
  String? imageCourse;
  String? createBy;
  String? progress;
  List<String>? favorites;
  List<String>? learnings;
  double? rating;
  double? totalProgress;

  CourseModel();

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel()
    ..id = json['id']
    ..name = json['name']
    ..category = json['category']
    ..description = json['description']
    ..imageCourse = json['imageCourse']
    ..createBy = json['createBy']
    ..progress = json['progress']
    ..rating = json['rating'] ?? 0.0
    ..totalProgress = json['totalProgress']
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
      'rating': rating,
      'totalProgress' : totalProgress,
      'learnings': learnings?.map((e) => e).toList(),
      'favorites': favorites?.map((e) => e).toList(),
    };
  }
}
