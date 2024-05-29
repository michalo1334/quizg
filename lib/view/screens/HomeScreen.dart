import 'package:flutter/material.dart';

import '../../model/Quiz.dart';
import 'QuestionScreen.dart';

class HomeScreen extends StatelessWidget {

  Future<Quiz> futureQuiz1 = Quiz.fromRemoteEndpointJson("https://quiz-json-data.fra1.digitaloceanspaces.com/AWWW_egzamin0.json");
  Future<Quiz> futureQuiz2 = Quiz.fromRemoteEndpointJson("https://quiz-json-data.fra1.digitaloceanspaces.com/Grafika_egzamin0.json", allSingleChoice: true);

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
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _future(futureQuiz1, "AWWW"),
        _future(futureQuiz2, "Grafika"),
      ],
    ));
  }

  Widget _future(Future<Quiz> futureQuiz, String title) {
    return FutureBuilder(
      future: futureQuiz,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildButton(context, snapshot.data!, title);
        }

        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildButton(BuildContext context, Quiz quiz, String title) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => QuestionScreen(quiz: quiz)
        ));
      },
      child: Text(title),
    );
  }
}