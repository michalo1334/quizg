import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:quizg/view/Question/QuestionWidget.dart';
import 'package:quizg/view/screens/HomeScreen.dart';

import '../../model/Quiz.dart';
import 'SummaryScreen.dart';

class QuestionScreen extends StatelessWidget {
  final Quiz quiz;

  static const String layout = """
  . widget .
  . widget next
  """;

  const QuestionScreen({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: LayoutGrid(
          columnSizes: [1.fr, 4.fr, 1.fr],
          rowSizes: [2.fr, 4.fr],
          areas: QuestionScreen.layout,
          children: [
            QuestionWidget(question: quiz.current).inGridArea('widget'),
            _buildNextButton(context).inGridArea('next'),
          ]),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(5),
          ),
          onPressed: () {
            _nextQuestionOrFinish(context);
          },
          child: Center(child: const Icon(Icons.arrow_forward)),
        ),
      ),
    );
  }

  Widget _buildActionHome(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.home),
      onPressed: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen()));
      },
    );
  }

  Widget _buildActionFinish(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.done),
      onPressed: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => SummaryScreen(quiz: quiz)));
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('${quiz.questions.indexOf(quiz.current) + 1}/${quiz.questions.length}'),
      actions: [
        _buildActionHome(context),
        _buildActionFinish(context),
      ],
    );
  }

  void _nextQuestionOrFinish(BuildContext context) {
    quiz.next();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => quiz.finished
            ? SummaryScreen(quiz: quiz)
            : QuestionScreen(quiz: quiz)));
  }
}
