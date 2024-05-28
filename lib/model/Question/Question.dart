import 'package:flutter/material.dart';
import 'package:quizg/model/QuestionData.dart';

/*
I represent ABCD Question.
I can act either as single or multiple choice - this behavior is controlled by exactlyOne property.
 */
class Question extends ChangeNotifier {
  final QuestionData data;

  //Indices of selected choices
  Set<int> selected = {};

  final bool exactlyOne;

  Question(this.data, {this.exactlyOne = false});

  Question.singleChoice(this.data) : exactlyOne = true;
  Question.multipleChoice(this.data) : exactlyOne = false;

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(QuestionData.fromJson(json));
  }

  void select(int choiceIndex) {
    if(exactlyOne) {
      selected.clear();

      selected.add(choiceIndex);
    }
    else {
      selected.add(choiceIndex);
    }

    notifyListeners();
  }

  void deselect(int choiceIndex) {
    if(exactlyOne) {
      //Do nothing - in single choice mode, you can't deselect once selected
    }
    else {
      selected.remove(choiceIndex);
    }

    notifyListeners();
  }

  void toggleSelection(int choiceIndex) {
    if (isSelected(choiceIndex)) {
      deselect(choiceIndex);
    } else {
      select(choiceIndex);
    }
  }

  int selectedCorrectCount() {
    return selected.intersection(data.correct).length;

  }
  int selectedIncorrectCount() {
    return selected.difference(data.correct).length;
  }

  bool isSelected(int choiceIndex) {
    return selected.contains(choiceIndex);
  }

  bool get isSingleChoice => exactlyOne;
  bool get isMultipleChoice => !exactlyOne;

  Question asSingleChoice() {
    return Question(data, exactlyOne: true);
  }

  Question asMultipleChoice() {
    return Question(data, exactlyOne: false);
  }
}