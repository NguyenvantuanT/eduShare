class RemindModel {
  String? todoId;
  String? title;
  String? note;
  bool? isCompleted;
  String? dateCreate;
  int? color;

  RemindModel();

  factory RemindModel.fromJson(Map<String, dynamic> json) => RemindModel()
    ..title = json['title']
    ..note = json['note']
    ..isCompleted = json['isCompleted'] as bool? ?? false
    ..dateCreate = json['dateCreate']
    ..color = json['color'];

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'dateCreate': dateCreate,
      'color': color,
    };
  }
}
