import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Question/Question.dart';

class Quiz extends ChangeNotifier {
  late final List<Question> questions;

  final Iterator<Question> questionIterator;

  bool _finished = false;

  Quiz(this.questions, {bool shuffle = false})
      : questionIterator = questions.iterator {
    if (shuffle) {
      questions = List.from(questions);
      questions.shuffle();
    }
    next();
  }

  factory Quiz.fromPool(List<Question> pool, int count,
      {bool shuffle = false}) {
    var questions = pool.take(count);
    return Quiz(questions.toList(), shuffle: shuffle);
  }

  static Future<Quiz> fromRemoteEndpointJson(String url,
      {bool shuffle = false, onFinished}) async {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      var questions = List<Question>.from(jsonDecoded.map((e) => Question.fromJson(e)));
      return Quiz(questions, shuffle: shuffle);
    } else {
      throw Exception('Failed to load questions');
    }
  }

  bool next() {
    _finished = !questionIterator.moveNext();
    notifyListeners();

    return _finished;
  }

  Question get current => questionIterator.current;

  bool get finished => _finished;
}
