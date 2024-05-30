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

  String get layout => previewOnly ?
  """
    score   text    explanation
    choices choices choices
    divider divider divider
  """ :
  """
    text    text    text
    choices choices choices
    choices choices choices
  """;

  const QuestionWidget({super.key, required this.question, bool previewOnly = false}) : _previewOnly = previewOnly;

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      columnSizes: [50.px, 1.fr, 50.px],
      rowSizes: [1.fr, 2.fr, 30.px],
      areas: widget.layout,
      children: [
        _buildQuestionText(context).inGridArea('text'),
        _buildChoices(context).inGridArea('choices'),
        if(widget.previewOnly) _buildExplanationButton(context).inGridArea('explanation'),
        if(widget.previewOnly) _buildQuestionScore(context).inGridArea('score'),
        if(widget.previewOnly) Divider().inGridArea('divider'),
      ],
    );
  }

  Widget _buildQuestionText(BuildContext context) {
    var sheet = MarkdownStyleSheet(p: Theme.of(context).textTheme.bodyLarge);

    return Center(child: MarkdownBody(data: widget.question.data.questionText, styleSheet: sheet,));
  }

  void _showExplanationModalSheet(BuildContext context) {
    var expl = widget.question.data.explanation;
    var textBody = expl == null ? Container() : Markdown(data: expl);

    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(child: textBody),
          );
        }
    );
  }

  Widget _buildQuestionScore(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text("pkt. ${widget.question.score.toStringAsFixed(2)}"),
    );
  }

  Widget _buildExplanationButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          onPressed: (){_showExplanationModalSheet(context);},
          icon: Icon(Icons.info, color: widget.question.data.explanation == null ? Colors.grey : Colors.red)
      ),
    );
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
      var exactlyOne = widget.question.isSingleChoice;

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