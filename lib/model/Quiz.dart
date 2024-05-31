import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Question/Question.dart';

class Quiz extends ChangeNotifier {
  List<Question> questions;

  Iterator<Question> questionIterator;

  bool _finished = false;

  Quiz(this.questions, {bool shuffle = false})
      : questionIterator = questions.iterator {
    if (shuffle) {
      questions = List.from(questions);
      questions.shuffle();
      questionIterator = questions.iterator;
    }
    next();
  }

  factory Quiz.fromPool(List<Question> pool, int count,
      {bool shuffle = true}) {
    var qq = pool.take(count);
    return Quiz(qq.toList(), shuffle: shuffle);
  }

  double get score => questions.fold(0, (previousValue, element) => previousValue + element.score);

  bool next() {
    _finished = !questionIterator.moveNext();
    notifyListeners();

    return _finished;
  }

  Question get current => questionIterator.current;

  bool get finished => _finished;
}
