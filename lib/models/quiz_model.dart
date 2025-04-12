import 'package:chat_app/utils/enum.dart';

class QuizModel {
  String? quizId; 
  String? courseId;
  String? question;
  QuizType? type;
  List<String>? options; 
  int? correctOptionIndex; 
  List<int>? correctOptionIndices; 
  String? correctAnswer; 
  
  QuizModel({
    this.quizId,
    this.courseId,
    this.question,
    this.type,
    this.options,
    this.correctOptionIndex,
    this.correctOptionIndices,
    this.correctAnswer,
  });

  Map<String, dynamic> toJson() => {
        'quizId': quizId,
        'courseId': courseId,
        'question': question,
        'type': type?.name,
        'options': options,
        if (correctOptionIndex != null)'correctOptionIndex': correctOptionIndex,
        if (correctOptionIndices != null)'correctOptionIndices': correctOptionIndices,
        if (correctAnswer != null) 'correctAnswer': correctAnswer,
      };

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        quizId: json['quizId'],
        courseId: json['courseId'],
        question: json['question'],
        type: QuizType.values.firstWhere(
          (e) => e.toString().split('.').last == json['type'],
        ),
        options:
            json['options'] != null ? List<String>.from(json['options']) : null,
        correctOptionIndex: json['correctOptionIndex'],
        correctOptionIndices: json['correctOptionIndices'] != null
            ? List<int>.from(json['correctOptionIndices'])
            : null,
        correctAnswer: json['correctAnswer'],
      );
}
