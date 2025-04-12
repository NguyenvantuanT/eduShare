import 'dart:ui';

import 'package:chat_app/components/debouncer.dart';
import 'package:chat_app/models/lesson_model.dart';
import 'package:chat_app/services/remote/learning_progress_services.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerServices {
  YoutubePlayerController? controller;

  void initialize(
    String videoId, {
    int startAt = 0,
  }) {
    controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(startAt: startAt, autoPlay: false, loop: false),
    );
  }

  void loadVideo(String videoId, {int startAt = 0}) =>
      controller?.load(videoId, startAt: startAt);
  void dispose() => controller?.dispose();
}

class ProgressTracker {
  LearningProgressServices services;
  Debouncer debouncer = Debouncer(milliseconds: 200);

  ProgressTracker(this.services);

  void saveProgress({
    String? docIdCourse,
    String? lessonId,
    double? progress,
    bool? isCompleted,
    VoidCallback? onSuccess,
  }) {
    debouncer.run(() {
      final progressModel = LearningProgressModel(
        progress: progress,
        isCompleted: isCompleted ?? false,
      );
      services
          .createLessonProgress(
            docIdCourse: docIdCourse,
            lessonId: lessonId,
            value: progressModel,
          )
          .then((_) => onSuccess?.call())
          .catchError((error) {
        debugPrint('Lỗi khi lưu tiến độ: $error');
      });
    });
  }

  Future<LearningProgressModel?> getProgress({
    String? docIdCourse,
    String? lessonId,
  }) async {
    return await services.getLessonProgress(
      docIdCourse: docIdCourse,
      lessonId: lessonId,
    );
  }
}
