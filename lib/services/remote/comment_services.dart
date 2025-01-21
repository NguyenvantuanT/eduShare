import 'package:chat_app/models/comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CommentServicesImpl {
  Future<CommentModel> createComment(String idCourse, CommentModel comment);
  Future<dynamic> updateComment(String idCourse, CommentModel comment);
  Future<List<CommentModel>> getComments(String idCourse);
  Future<dynamic> getRating(String idCourse);
}

class CommentServices implements CommentServicesImpl {
  CollectionReference courseCollection =
      FirebaseFirestore.instance.collection('courses');
  final commentCollection = 'comments';

  @override
  Future<CommentModel> createComment(
      String idCourse, CommentModel comment) async {
    DocumentReference<Map<String, dynamic>> data = await courseCollection
        .doc(idCourse)
        .collection(commentCollection)
        .add(comment.toJson());

    return comment..commentId = data.id;
  }

  @override
  Future<List<CommentModel>> getComments(String idCourse) async {
    QuerySnapshot<Map<String, dynamic>> datas = await courseCollection
        .doc(idCourse)
        .collection(commentCollection)
        .get();
    return datas.docs
        .map((e) => CommentModel.fromJson(e.data())..commentId = e.id)
        .toList();
  }

  @override
  Future<dynamic> updateComment(
    String idCourse,
    CommentModel comment,
  ) async {
    await courseCollection
        .doc(idCourse)
        .collection(commentCollection)
        .doc(comment.commentId)
        .update(comment.toJson());
  }

  @override
  Future<dynamic> getRating(String idCourse) async {
    QuerySnapshot<Map<String, dynamic>> datas = await courseCollection
        .doc(idCourse)
        .collection(commentCollection)
        .get();
    List<CommentModel> comments = datas.docs
        .map((e) => CommentModel.fromJson(e.data())..commentId = e.id)
        .toList();

    double totalRating = 0.0;
    for (CommentModel comment in comments) {
      totalRating += comment.rating ?? 0.0;
    }
    await courseCollection.doc(idCourse).update(
      {'rating': comments.isEmpty ? 0.0 : totalRating / comments.length},
    );
  }
}
