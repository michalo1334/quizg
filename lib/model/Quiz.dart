import 'package:flutter/material.dart';

import 'Question/Question.dart';

class Quiz extends ChangeNotifier {
  late final List<Question> questions;

  final Iterator<Question> questionIterator;

  bool _finished = false;

  Quiz(this.questions, {shuffle = false}) : questionIterator = questions.iterator {
    if(shuffle) {
      questions = List.from(questions);
      questions.shuffle();
    }
  }

  factory Quiz.fromPool(List<Question> pool, int count, {shuffle = false}) {
    var questions = pool.take(count);
    return Quiz(questions.toList(), shuffle: shuffle);
  }

  bool next() {
    _finished = questionIterator.moveNext();
    notifyListeners();

    return _finished;
  }

  Question get current => questionIterator.current;

  bool get finished => _finished;
}