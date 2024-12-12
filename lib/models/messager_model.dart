class MessagerModel {
  String? docId;
  String? id;
  String? createBy;
  String? avatar;
  String? text;
  bool? isRecalled;

  MessagerModel();

  factory MessagerModel.toJson(Map<String, dynamic> json) => MessagerModel()
    ..id = json['id']
    ..createBy = json['createBy']
    ..avatar = json['avatar']
    ..text = json['text']
    ..isRecalled = json["isRecalled"];

  Map<String, dynamic> toJson() => {
        'id': id,
        'createBy': createBy,
        'avatar': avatar,
        'text': text,
        'isRecalled': isRecalled,
      };
}
