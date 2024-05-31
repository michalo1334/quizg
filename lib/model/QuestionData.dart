import 'package:mongo_dart/mongo_dart.dart';

enum QuestionType {
  singleChoice,
  multipleChoice,
}

class QuestionData {
  final ObjectId? mongodbID;

  //Plain or markdown
  final String questionText;

  final List<String> choices;

  //Stored as indices to choices array, shuffling is done by separate method (returns ABCD map)
  final Set<int> correct;

  //Plain or markdown
  final String? explanation;

  final QuestionType type;

  QuestionData({
    this.questionText = "No data",
    this.choices = const [],
    this.correct = const {},
    this.explanation,
    this.type = QuestionType.multipleChoice,
    this.mongodbID,
  });

  factory QuestionData.fromMap(Map<String, dynamic> map) => QuestionData(
      questionText: map["question"],
      choices: List<String>.from(map["choices"]),
      correct: Set<int>.from(map["correct"]),
      explanation: map["explanation"] == "" ? null : map["explanation"],
      type: switch(map['type']) {
        null => QuestionType.multipleChoice,
        "singleChoice" => QuestionType.singleChoice,
        "multipleChoice" => QuestionType.multipleChoice,
        Object() => throw UnimplementedError(),
      });

//Return mapping letter->choice index, optionally shuffle
  Map<String, int> letteredChoices({bool shuffle = false}) {
    var indices = List<int>.generate(choices.length, (i) => i);
    if (shuffle) indices.shuffle();

    var letters = List<String>.generate(
        choices.length, (i) => String.fromCharCode(i + 65));

    return Map<String, int>.fromIterables(letters, indices);
  }

//Return mapping letter->choice text, optionally shuffle
  Map<String, String> letteredChoiceTexts({bool shuffle = false}) =>
      letteredChoices(shuffle: shuffle).map((k, v) => MapEntry(k, choices[v]));

//Return if the choice index is correct
  bool isCorrect(int? choiceIndex) =>
      choiceIndex == null ? correct == <int>{} : correct.contains(choiceIndex);

  bool get isSingleChoice => type == QuestionType.singleChoice;

  bool get isMultipleChoice => type == QuestionType.multipleChoice;

  Map<String, dynamic> toMap() => {
        "_id": mongodbID,
        "question": questionText,
        "choices": choices,
        "correct": correct.toList(),
        "explanation": explanation,
        "type": type == QuestionType.singleChoice
            ? "singleChoice"
            : "multipleChoice",
      };
}
