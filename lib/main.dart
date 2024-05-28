import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quizg/view/Question/QuestionWidget.dart';
import 'model/Question/Question.dart';
import 'model/QuestionData.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Question question;

  MyApp({Key? key}) : question = Question(QuestionData(
    questionText: "What is the capital of France?",
    choices: ["Paris", "London", "Berlin", "Madrid"],
    correct: {0},
  )), super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo'),
        ),
        body: QuestionWidget(question: question),
      ),
    );
  }
}