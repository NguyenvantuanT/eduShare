import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/services/remote/learning_progress_services.dart';
import 'package:chat_app/services/remote/lesson_services.dart';
import 'package:chat_app/services/remote/video_player_services.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LessonVM extends BaseViewModel {
  LessonVM({
    required this.docIdCourse,
    required this.index,
    this.updateProg,
  });

  final String docIdCourse;
  final int index;
  final VoidCallback? updateProg;
  late ProgressTracker progressTracker;

  VideoPlayerServices videoPlayerServices = VideoPlayerServices();
  LessonServices lessonServices = LessonServices();
  LessonModel lesson = LessonModel();
  List<LessonModel> lessons = [];
  late int lessonIndex;
  List<String> tabNames = ['Information', 'Lessons'];
  int selectIndex = 0;
  double progress = 0.0;

  void onInit() {
    progressTracker = ProgressTracker(LearningProgressServices());
    lessonIndex = index;
    getVideo();
  }

  Future<void> getVideo() async {
    setBusy(true); 
    try {
      lessons = await lessonServices.getLessons(docIdCourse);
      lesson = lessons[lessonIndex];
      await getProgress(); 
      videoPlayerServices.initialize(
        lesson.videoPath ?? '',
        startAt: (progress * 1000).toInt(), 
      );
      videoPlayerServices.controller?.addListener(updateProgress);
    } catch (onError) {
      debugPrint('Lỗi khi tải video: $onError');
    } finally {
      setBusy(false);
      rebuildUi();
    }
  }

  Future<void> changeLesson(int index) async {
    if (lessonIndex != index) { 
      saveProgress(); 
      lessonIndex = index;
      lesson = lessons[lessonIndex];
      await getProgress();
      videoPlayerServices.loadVideo(
        lesson.videoPath ?? '',
        startAt: (progress * 1000).toInt(), 
      );
      rebuildUi();
    }
  }

  void changeIndex(int idx) {
    selectIndex = idx;
    rebuildUi();
  }

  Future<void> getProgress() async {
    try {
      final value = await progressTracker.getProgress(
        docIdCourse: docIdCourse,
        lessonId: lesson.lessonId ,
      );
      progress = value?.progress ?? 0.0; 
    } catch (error) {
      debugPrint('Lỗi khi lấy tiến độ: $error');
      progress = 0.0; 
    }
  }

  void updateProgress() {
    if (videoPlayerServices.controller == null) return;
    final duration = videoPlayerServices.controller!.metadata.duration.inSeconds;
    if (duration == 0) return;

    progress = videoPlayerServices.controller!.value.position.inSeconds / duration;

    if (!videoPlayerServices.controller!.value.isPlaying &&
        videoPlayerServices.controller!.value.position > Duration.zero) {
      saveProgress(); 
    }
    rebuildUi();
  }

  void saveProgress() {
    if (lesson.lessonId != null) {
      progressTracker.saveProgress(
        docIdCourse: docIdCourse,
        lessonId: lesson.lessonId!,
        progress: progress,
        onSuccess: () {
          updateProg?.call();
        },
      );
    }
  }

  @override
  void dispose() {
    videoPlayerServices.dispose();
    super.dispose();
  }
}