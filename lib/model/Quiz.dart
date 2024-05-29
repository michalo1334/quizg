import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Question/Question.dart';

class Quiz extends ChangeNotifier {
  late final List<Question> questions;

  final Iterator<Question> questionIterator;

  final void Function(Quiz)? onFinished = null;

  bool _finished = false;

  Quiz(this.questions, {bool shuffle = false, void Function(Quiz)? onFinished})
      : questionIterator = questions.iterator {
    if (shuffle) {
      questions = List.from(questions);
      questions.shuffle();
    }
    next();
  }

  factory Quiz.fromPool(List<Question> pool, int count,
      {bool shuffle = false, onFinished}) {
    var questions = pool.take(count);
    return Quiz(questions.toList(), shuffle: shuffle, onFinished: onFinished);
  }

  static Future<Quiz> fromRemoteEndpointJson(String url,
      {bool shuffle = false, onFinished, allSingleChoice = false}) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var questions = List<Question>.from(jsonDecode(utf8.decode(response.bodyBytes)).map((e) => allSingleChoice ? Question.fromJson(e).asSingleChoice() : Question.fromJson(e).asMultipleChoice()));
      return Quiz(questions, shuffle: shuffle, onFinished: onFinished);
    } else {
      throw Exception('Failed to load questions');
    }
  }

  bool next() {
    _finished = !questionIterator.moveNext();
    notifyListeners();

    if (finished) {
      onFinished?.call(this);
    }

    return _finished;
  }

  Question get current => questionIterator.current;

  bool get finished => _finished;
}
