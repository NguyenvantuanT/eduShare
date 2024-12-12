class UserModel {
  String? name;
  String? email;
  String? avatar;

  UserModel();

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel()
    ..name = json['name']
    ..email = json['email']
    ..avatar = json['avatar'];

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'name': name,
      'email': email,
    };
  }
}
