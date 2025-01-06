class LessonModel {
  String? id;
  String? name;
  String? videoPath;
  String? description;

  LessonModel();

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel()
      ..id = json['id'] as String
      ..name = json['name'] as String
      ..videoPath = json['videoPath']
      ..description = json['description'];
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
