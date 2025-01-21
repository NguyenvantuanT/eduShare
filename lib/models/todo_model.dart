class TodoModel {
  String? todoId;
  String? title;
  String? note;
  bool? isCompleted;
  String? dateCreate;
  int? color;

  TodoModel();

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel()
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
