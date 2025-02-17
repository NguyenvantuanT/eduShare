import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/services/local/shared_prefs.dart';
import 'package:chat_app/services/remote/learning_progress_services.dart';
import 'package:chat_app/services/remote/lesson_services.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonVM extends BaseViewModel {
  LessonVM({
    required this.docIdCourse,
    required this.index,
    this.updateProg,
  });

  final String docIdCourse;
  final int index;
  final VoidCallback? updateProg;

  LearningProgressServices learProgServices = LearningProgressServices();
  LearningProgressModel learProg = LearningProgressModel();
  LessonServices lessonServices = LessonServices();
  YoutubePlayerController? controller;
  LessonModel lesson = LessonModel();
  List<LessonModel> lessons = [];
  late int lessonIndex;
  String email = SharedPrefs.user?.email ?? '';
  List<String> tabNames = ['Information', 'Lessons'];
  int selectIndex = 0;

  void onInit() {
    lessonIndex = index;
    getVideo();
  }

  void changeLesson() {
    lessonIndex = index;
    lesson = lessons[lessonIndex];
    controller?.load(lesson.videoPath!);
    rebuildUi();
  }

  

  void changeIndex(int idx) {
    selectIndex = idx;
    rebuildUi();
  }

  void getVideo() {
    lessonServices.getLessons(docIdCourse).then((values) {
      lessons = values;
      lesson = lessons[lessonIndex];

      getProgress();

      controller = YoutubePlayerController(
        initialVideoId: lesson.videoPath!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          loop: false,
        ),
      )..addListener(updateProgress);

      rebuildUi();
    }).catchError((onError) {
      debugPrint('Lỗi khi tải video: $onError');
    });
  }

  void getProgress() {
    learProgServices
        .getLessonProgress(docIdCourse: docIdCourse, lessonId: lesson.lessonId)
        .then((value) {
      if (value == null) {
        learProg = LearningProgressModel(isCompleted: false, progress: 0.0);
        learProgServices.createLessonProgress(
          docIdCourse: docIdCourse,
          lessonId: lesson.lessonId,
          value: learProg,
        );
        rebuildUi();
      }
      learProg = value ?? LearningProgressModel();
      rebuildUi();
    });
  }

  void updateProgress() {
    if (controller == null) return;
    if (controller!.metadata.duration.inSeconds == 0) return;

    final duration = controller!.metadata.duration.inSeconds;
    final position = controller!.value.position.inSeconds;

    double progress = position / duration;

    learProg.progress = progress;

    rebuildUi();
    updateProg?.call();
    saveProgress(progress);
  }

  void saveProgress(double progress) {
    if (lesson.lessonId == null || docIdCourse.isEmpty) return;

    bool isCompleted = progress >= 0.9;

    LearningProgressModel updatedProgress = LearningProgressModel(
      progress: progress,
      isCompleted: isCompleted,
    );

    learProgServices
        .updateLessonProgress(
          docIdCourse: docIdCourse,
          lessonId: lesson.lessonId ?? '',
          value: updatedProgress,
        )
        .then((_) {})
        .catchError((error) {
      debugPrint('Lỗi khi lưu tiến độ: $error');
    });
  }
}
