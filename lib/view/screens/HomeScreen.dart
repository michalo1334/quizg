import 'package:flutter/material.dart';

import '../../model/Question/Question.dart';
import '../../model/Quiz.dart';
import '../../model/QuizManager.dart';
import 'QuestionScreen.dart';

class HomeScreen extends StatelessWidget {

  final QuizManager manager = QuizManager.instance;

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home")
      ),
        body: _buildBody(context)
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder(
        future: manager.subjects(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            else {
              return _buildSubjectGrid(context, snapshot.data!);
            }
          }
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }
  
  Widget _buildSubjectGrid(BuildContext context, List<String> subjects) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: subjects.map((e) => _buildSubjectGridTile(context, e)).toList(),
    );
  }
  
  Widget _buildSubjectGridTile(BuildContext context, String subjectName) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            Text(subjectName, style: TextStyle(color: Colors.white, fontSize: 24)),
            _buildSubjectGridTileQuizButtons(context, subjectName)
          ],
        )
      ),
    );
  }

  Widget _buildSubjectGridTileQuizButtons(BuildContext context, String subjectName) {
    return FutureBuilder(
      future: Future.wait([manager.questionsBySubject(subjectName), manager.quizesBySubject(subjectName)]),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          else {
            var questionsBySubject = snapshot.data![0] as List<Question>;
            var quizzesBySubject = snapshot.data![1] as Map<String, Quiz>;
            return _buildQuizButtons(context, quizzesBySubject, questionsBySubject);
          }
        }
        else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

  Widget _buildQuizButtons(BuildContext context, Map<String, Quiz> quizzes, List<Question> questions) {
    return Column(
      children: [
        ...quizzes.keys.map((e) => _buildQuizButton(context, e, quizzes[e]!)),
        Divider(),
        _buildQuizButton(context, "Losowy quiz - 10 pytań", Quiz.fromPool(questions, 10)),
        _buildQuizButton(context, "Losowy quiz - 20 pytań", Quiz.fromPool(questions, 20)),
        _buildQuizButton(context, "Losowy quiz - 40 pytań", Quiz.fromPool(questions, 40)),
      ]
    );
  }

  Widget _buildQuizButton(BuildContext context, String quizName, Quiz quiz) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuestionScreen(quiz: quiz)));
        },
        child: Text(quizName),
      ),
    );
  }
}