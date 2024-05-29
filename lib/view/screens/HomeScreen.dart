import 'package:flutter/material.dart';

import '../../model/Quiz.dart';
import 'QuestionScreen.dart';

class HomeScreen extends StatelessWidget {

  Future<Quiz> futureQuiz = Quiz.fromRemoteEndpointJson("https://quiz-json-data.fra1.digitaloceanspaces.com/AWWW_egzamin0.json");

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
    return Center(child: _future());
  }

  Widget _future() {
    return FutureBuilder(
      future: futureQuiz,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildButton(context, snapshot.data!);
        }

        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildButton(BuildContext context, Quiz quiz) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => QuestionScreen(quiz: quiz)
        ));
      },
      child: Text("Start Quiz"),
    );
  }
}