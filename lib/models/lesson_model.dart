class LessonModel {
  String? lessonId;
  String? id;
  String? name;
  String? videoPath;
  String? description;

  LessonModel();

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel()
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..videoPath = json['videoPath'] as String?
      ..description = json['description'] as String?;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'videoPath': videoPath,
      'description': description,
    };
  }
}

class LearningProgressModel {
  double? progress;
  bool? isCompleted;
  LearningProgressModel({this.progress, this.isCompleted});

  factory LearningProgressModel.fromJson(Map<String, dynamic> json) {
    return LearningProgressModel(
      progress: json['progress'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() => {
        'progress': progress,
        'isCompleted': isCompleted,
      };
}
