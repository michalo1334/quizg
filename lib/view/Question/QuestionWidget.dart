import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../model/Question/Question.dart';
import '../../model/Quiz.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;

  final bool _previewOnly;

  bool get previewOnly => _previewOnly;

  static const String layout =
  """
    text     
    choices   
  """;

  const QuestionWidget({super.key, required this.question, bool previewOnly = false}) : _previewOnly = previewOnly;

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [1.fr],
      rowSizes: [1.fr, 2.fr],
      areas: QuestionWidget.layout,
      children: [
        _buildQuestionText(context).inGridArea('text'),
        _buildChoices(context).inGridArea('choices'),
      ],
    );
  }

  Widget _buildQuestionText(BuildContext context) {
    var sheet = MarkdownStyleSheet(p: Theme.of(context).textTheme.bodyLarge);

    return Center(child: MarkdownBody(data: widget.question.data.questionText, styleSheet: sheet,));
  }

  Widget _buildChoices(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget
            .question
            .data
            .letteredChoices(shuffle: false)
            .entries
            .map((entry) {
          return _buildChoice(context, entry.key, widget.question.data.choices[entry.value], entry.value);
        }).toList(),
      ),
    );
  }

  Color _choiceColor(int choiceIdx) {
    if(widget.previewOnly) {
      var selected = widget.question.isSelected(choiceIdx);
      var correct = widget.question.data.isCorrect(choiceIdx);
      var exactlyOne = widget.question.exactlyOne;

      //"truth table"
      //Single choice - green if selected and correct, red if selected and incorrect
      //Multiple choice - additionally yellow if correct but not selected
      return switch((selected, correct)) {
        (true, true) => Colors.green,
        (true, false) => Colors.red,
        (false, true) => Colors.yellow,
        (false, false) => Colors.white,
      };
    }
    else {
      return widget.question.isSelected(choiceIdx) ? Colors.blue : Colors.white;
    }
  }

  Widget _buildChoice(BuildContext context, String letter, String choice, int choiceIdx) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(_choiceColor(choiceIdx)),
          ),
            onPressed: () => setState(() {
              widget.question.toggleSelection(choiceIdx);
            }),
            child: Row(
              children: [
                Text(letter, style: Theme.of(context).textTheme.bodyLarge),
                Text(". "),
                Expanded(child: Text(choice, textAlign: TextAlign.center)),
              ]),
        ),
      ),
    );
  }
}