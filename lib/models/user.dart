class UserModel {
  String? uid;
  String? name;
  String? imgURL;

  UserModel({
    this.uid,
    this.name,
    this.imgURL, 
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    imgURL = json['imgURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['imgURL'] = imgURL;
    return data;
  }
}
