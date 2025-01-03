class LessonModel {
  String? id;
  String? name;
  int? duration;
  String? videoPath;
  String? description;

  LessonModel();

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel()
      ..id = json['id'] as String
      ..name = json['name'] as String
      ..duration = json['duration'] as int
      ..videoPath = json['videoPath']
      ..description = json['description'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'videoPath': videoPath,
      'description': description,
    };
  }
}
