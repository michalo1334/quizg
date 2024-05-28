import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../model/Question/Question.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;

  static const String layout =
  """
   . text .
   . choices .
   . . .
  """;

  const QuestionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr, 4.fr, 1.fr],
      rowSizes: [flex(2), flex(3), flex(1)],
      areas: layout,
      children: [
        _buildQuestionText(context).inGridArea('text'),
        _buildChoices(context).inGridArea('choices'),
      ],
    );
  }

  Widget _buildQuestionText(BuildContext context) {
    return MarkdownBody(data: question.data.questionText);
  }

  Widget _buildChoices(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: question.data.choices.map((choice) => _buildChoice(context, choice)).toList(),
      ),
    );
  }

  Widget _buildChoice(BuildContext context, String choice) {
    return Text(choice, style: TextStyle(fontSize: 20));
  }
}