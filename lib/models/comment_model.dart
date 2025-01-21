class CommentModel {
  String? commentId;
  String? name;
  String? avatar;
  String? comment;
  double? rating;

  CommentModel();

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel()
    ..name = json['name']
    ..avatar = json['avatar']
    ..comment = json['comment']
    ..rating = json['rating'];
  
  Map<String,dynamic> toJson() {
    return {
      'name' : name,
      'avatar' : avatar,
      'comment' : comment,
      'rating' : rating,
    };
  }
}
