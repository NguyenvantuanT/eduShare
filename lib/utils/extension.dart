import 'package:chat_app/utils/enum.dart';
import 'package:flutter/material.dart';

extension QuizTypeExt on QuizType {
  String get displayName {
    switch (this) {
      case QuizType.singleChoice:
        return "Single choice";
      case QuizType.multipleChoice:
        return "Multiple choice";
      default:
        return "QA choice";
    }
  }
}

extension DifficultyLevelExt on DifficultyLevel {
  String get displayName {
    switch (this) {
      case DifficultyLevel.easy:
        return "Easy";
      case DifficultyLevel.hard:
        return "Hard";
      default:
        return "Normal";
    }
  }
}

extension BuildContextExt on BuildContext {
  EdgeInsets get padding => MediaQuery.of(this).padding;
}

extension DateTimeExt on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }
}

extension IntExt on int {
  SizedBox get sizeWidth => SizedBox(width: toDouble());
  SizedBox get sizeHeight => SizedBox(height: toDouble());
}

extension DoubleExt on double {
  SizedBox get sizeWidth => SizedBox(width: this);
  SizedBox get sizeHeight => SizedBox(height: this);
}
