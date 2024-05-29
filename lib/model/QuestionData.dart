enum QuestionType {
  singleChoice,
  multipleChoice,
}

class QuestionData {
  //Plain or markdown
  final String questionText;

  final List<String> choices;

  //Stored as indices to choices array, shuffling is done by separate method (returns ABCD map)
  final Set<int> correct;

  //Plain or markdown
  final String explanation;

  final QuestionType type;

  QuestionData({
    this.questionText = "No data",
    this.choices = const [],
    this.correct = const {},
    this.explanation = "",
    this.type = QuestionType.multipleChoice,
  });

  /*
  {
    "question": "What is the capital of France?",
    "choices": ["Paris", "London", "Berlin", "Madrid"],
    "correct": [0],
    "explanation": "Paris is the capital of France."
  }
   */
  factory QuestionData.fromJson(Map<String, dynamic> json) =>
      switch(json) {
        {
        "question": String questionText,
        "choices": List<dynamic> choices,
        "correct": List<dynamic> correct,
        "explanation": String explanation
        } =>
            QuestionData(
                questionText: questionText,
                choices: List<String>.from(choices),
                correct: Set<int>.from(correct),
                explanation: explanation,
                type: json['type'] == null ? QuestionType.multipleChoice : json['type'] == "singleChoice" ? QuestionType.singleChoice : QuestionType.multipleChoice
            ),
        _ => throw const FormatException("Invalid JSON")
      };

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
    letteredChoices(shuffle: shuffle)
        .map((k, v) => MapEntry(k, choices[v]));

//Return if the choice index is correct
bool isCorrect(int? choiceIndex) =>
    choiceIndex == null ? correct == <int>{} : correct.contains(choiceIndex);

bool get isSingleChoice => type == QuestionType.singleChoice;
bool get isMultipleChoice => type == QuestionType.multipleChoice;


String toJson() => '''
  {
    "question": "$questionText",
    "choices": ${choices.map((e) => '"$e"').toList()},
    "correct": $correct,
    "explanation": "$explanation",
    "type": "${type == QuestionType.singleChoice ? "singleChoice" : "multipleChoice"}"
  }
  ''';}