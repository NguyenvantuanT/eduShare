import 'dart:ui';

import 'package:chat_app/components/delight_toast_show.dart';
import 'package:chat_app/models/comment_model.dart';
import 'package:chat_app/models/course_model.dart';
import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/models/quiz_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/pages/create_todo/create_todo_page.dart';
import 'package:chat_app/resource/themes/app_colors.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/comment_services.dart';
import 'package:chat_app/services/remote/course_services.dart';
import 'package:chat_app/services/remote/learning_progress_services.dart';
import 'package:chat_app/services/remote/lesson_services.dart';
import 'package:chat_app/services/remote/quiz_services.dart';
import 'package:chat_app/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CourseDetailVM extends BaseViewModel {
  CourseDetailVM(this.docId, {this.onUpdate});
  final String docId;
  final VoidCallback? onUpdate;

  LearningProgressServices learProgServices = LearningProgressServices();
  TextEditingController commentController = TextEditingController();
  QuizServices quizServices = QuizServices();
  DifficultyLevel? selectedDifficulty = DifficultyLevel.easy;
  CourseServices courseServices = CourseServices();
  LessonServices lessonServices = LessonServices();
  CommentServices commentServices = CommentServices();
  CourseModel course = CourseModel();
  UserModel user = SharedPrefs.user ?? UserModel();
  List<LessonModel> lessons = [];
  List<CommentModel> comments = [];
  List<QuizModel> quizzes = [];
  bool isFavorite = false;
  bool isLearning = false;
  bool isLoading = false;

  void onInit() {
    getCourse();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }


  void selectDifficulty(DifficultyLevel? difficulty) {
    selectedDifficulty = difficulty;
    rebuildUi();
  }

  void getCourse() {
    isLoading = true;
    rebuildUi();
    courseServices
        .getCourse(docId)
        .then((value) {
          course = value;
          isFavorite = (course.favorites ?? []).contains(user.email);
          isLearning = (course.learnings ?? []).contains(user.email);

          Future.wait([
            lessonServices.getLessons(docId),
            commentServices.getComments(docId)
          ]).then((results) {
            lessons = results[0] as List<LessonModel>;
            comments = results[1] as List<CommentModel>;
            getProgress();
          });
        })
        .catchError((error) {})
        .whenComplete(() {
          isLoading = false;
          rebuildUi();
        });
  }

  Future<void> getProgress() async {
    try {
      for (var lesson in lessons) {
        final progress = await learProgServices.getLessonProgress(
          docIdCourse: docId,
          lessonId: lesson.lessonId ?? '',
        );
        lesson.progress = progress?.progress ?? 0.0;
      }
      rebuildUi();
    } catch (error) {
      debugPrint('Lỗi khi lấy tiến độ: $error');
    }
  }

  void toggleFavorite(BuildContext context) {
    isFavorite = !isFavorite;
    rebuildUi();
    courseServices.toggleFavorite(course, isFavorite).then((_) {
      if (!context.mounted) return;
      DelightToastShow.showToast(
          context: context,
          icon: Icons.favorite,
          iconColor: isFavorite ? AppColor.blue : null,
          text:
              'Course has been ${isFavorite ? 'add' : 'remote'} your favorites 😍',
          color: AppColor.bgColor.withOpacity(0.8));
      rebuildUi();
    }).catchError((onError) {});
  }

  void toggleLearning(BuildContext context) {
    isLearning = !isLearning;
    rebuildUi();
    courseServices.toggleLearning(course, isLearning).then((_) {
      onUpdate?.call();
      if (!context.mounted) return;
      DelightToastShow.showToast(
        context: context,
        icon: Icons.book,
        iconColor: isLearning ? AppColor.blue : null,
        text:
            'Course has been ${isLearning ? 'added to' : 'removed from'} your learning 😍',
        color: AppColor.bgColor.withOpacity(0.8),
      );
      rebuildUi();
    }).catchError((onError) {
      debugPrint("Error: $onError");
    });
  }

  void createComment() {
    CommentModel comment = CommentModel()
      ..avatar = user.avatar ?? ""
      ..name = user.name ?? ""
      ..comment = commentController.text.trim();
    commentServices.createComment(docId, comment).then((value) {
      comments.add(value);
      commentController.clear();
      rebuildUi();
    });
  }

  void updateRating(CommentModel comment, double rating) {
    commentServices.updateComment(docId, comment..rating = rating).then((_) {
      onUpdate?.call();
      commentServices.getRating(docId).then((courseRating) {
        comments.singleWhere((e) => e.commentId == comment.commentId).rating =
            rating;
        rebuildUi();
      });
    });
  }

  void addCourseTodo(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateTodoPage(title: course.name),
        ));
  }
}
