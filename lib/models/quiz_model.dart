class QuizModel {
  String? quizId;
  String? correctOption;
  List<String>? options;
  String? question;

  QuizModel({
    this.correctOption,
    this.options,
    this.question,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      correctOption: json['correctOption'] as String?,
      options: json['options'] == null
          ? null
          : (json['options'] as List?)?.map((e) => e.toString()).toList(),
      question: json['question'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'correctOption': correctOption,
        'options': options ?? [],
        'question': question,
      };
}
