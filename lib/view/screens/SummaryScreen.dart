import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:quizg/view/Question/QuestionWidget.dart';

import '../../model/Quiz.dart';
import 'HomeScreen.dart';

class SummaryScreen extends StatelessWidget {
  final Quiz quiz;

  static const String layout = """
  . stats .
  . widget .
  """;

  bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;

  const SummaryScreen({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Podsumowanie:'),
        actions: [
          _buildActionHome(context),
        ],
      ),
        body: LayoutGrid(
            columnSizes: [1.fr, 90.fr, 1.fr],
            rowSizes: [1.fr, 10.fr],
            areas: SummaryScreen.layout,
            children: [
          _buildList(context).inGridArea('widget'),
          _buildStats(context).inGridArea('stats'),
        ]));
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

  Widget _buildStats(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Statystyki'),
            Text('Punkty: 666'),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
      itemCount: quiz.questions.length,
      itemBuilder: (context, index) {
        var question = quiz.questions[index];
        return FractionallySizedBox(widthFactor: isMobile(context) ? 1.0 : 0.7, child: SizedBox(height: 400, child: QuestionWidget(question: question, previewOnly: true)));
      },
    );
  }
}