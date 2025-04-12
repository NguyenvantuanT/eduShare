class TriviaModel {
  String? type;
  String? difficulty;
  String? category;
  String? question;
  String? correctAnswer;
  List<String>? incorrectAnswers;

  TriviaModel({
    this.type,
    this.difficulty,
    this.category,
    this.question,
    this.correctAnswer,
    this.incorrectAnswers,
  });

  TriviaModel.fromJson(Map<String, dynamic> json) {
    type = json["type"];
    difficulty = json["difficulty"];
    category = json["category"];
    question = json["question"];
    correctAnswer = json["correct_answer"];
    incorrectAnswers = json["incorrect_answers"] == null
        ? null
        : List<String>.from(json["incorrect_answers"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["type"] = type;
    data["difficulty"] = difficulty;
    data["category"] = category;
    data["question"] = question;
    data["correct_answer"] = correctAnswer;
    if (incorrectAnswers != null) {
      data["incorrect_answers"] = incorrectAnswers;
    }
    return data;
  }
}
