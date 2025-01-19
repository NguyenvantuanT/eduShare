class UserModel {
  String? name;
  String? email;
  String? avatar;
  List<String>? learnings;
  List<String>? favorites;

  UserModel();

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel()
    ..name = json['name']
    ..email = json['email']
    ..avatar = json['avatar']
    ..learnings = json['learnings'] != null
        ? List<String>.from(json['learnings'])
        : null
    ..favorites = json['favorites'] != null
        ? List<String>.from(json['favorites'])
        : null;

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'name': name,
      'email': email,
      'learnings': learnings?.map((e) => e).toList(),
      'favorites': learnings?.map((e) => e).toList(),
    };
  }
}
