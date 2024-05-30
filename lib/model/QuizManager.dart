import 'dart:convert';

import 'package:http/http.dart' as http;

import 'Question/Question.dart';
import 'Quiz.dart';

class QuizManager {
  QuizManager._privateConstructor();

  static const String connectionString =
      "mongodb://quiz:quiz123@134.122.67.190:27017/Quiz?authSource=admin";
  static const String databaseName = "quiz";
  static const String collectionName = "questions";

  static final QuizManager instance = QuizManager._privateConstructor();

  Future<List<String>> subjects() async {
    /*var db = mongo.Db(connectionString);
    await db.open();
    var collection = db.collection(collectionName);

    // Distinict by subject
    var result = List<String>.from((await collection.distinct("subject"))["values"]);

    db.close();

    return result;*/

    final url = Uri.parse('https://134.122.67.190:5000/subjects');

    //GET /subjects
    return http.get(url).then((response) {
      if (response.statusCode == 200) {
        final List<dynamic> subjects = jsonDecode(response.body);
        return subjects.map((e) => e.toString()).toList();
      } else {
        throw Exception('Failed to fetch subjects');
      }
    });
  }

  Future<List<Question>> questionsBySubject(String subject) async {
/*    var db = mongo.Db(connectionString);
    await db.open();
    var collection = db.collection(collectionName);

    var questions = await collection.find(mongo.where.eq("subject", subject)).toList();
    return questions.map((e) => Question.fromMap(e)).toList();*/

    final url = Uri.parse('https://134.122.67.190:5000/questionsBySubject?subject=$subject');

    //GET /questionsBySubject?subject={param}

    var result = await http.get(url, headers: {'subject': subject});

    if (result.statusCode == 200) {
      final List<dynamic> questions = jsonDecode(result.body);
      return questions.map((e) => Question.fromMap(e)).toList();
    } else {
      throw Exception('Failed to fetch questions');
    }
  }

  Future<Map<String, Quiz>> quizesBySubject(String subject) async {

    final url = Uri.parse('https://134.122.67.190:5000/questionsBySubject?subject=$subject');

    //GET /questionsBySubject?subject={param}

    var result = await http.get(url, headers: {'subject': subject});

    var questionsCursor = jsonDecode(result.body);


    // Group the questions by default_quiz_name and convert to Quiz
    var quizzes = <String, List<Question>>{};

    for (var questionMap in questionsCursor) {
      var question = Question.fromMap(questionMap);
      var quizName = questionMap['default_quiz_name'] as String;

      if (!quizzes.containsKey(quizName)) {
        quizzes[quizName] = [];
      }
      quizzes[quizName]!.add(question);
    }

    var quizzesMap = <String, Quiz>{};
    quizzes.forEach((key, value) {
      quizzesMap[key] = Quiz(value);
    });

    return quizzesMap;
  }

  //Selected choices == correct
  Future<bool> updateQuestionDataInDB(Question question) async {
/*
    var map = question.data.toMap();
    map['correct'] = question.selected.toList();


    var db = mongo.Db(connectionString);
    await db.open();
    var collection = db.collection(collectionName);

    var result = await collection.updateOne(
      mongo.where.eq("_id", question.data.mongodbID),
      mongo.modify.set('correct', map['correct'])
    );

    await db.close();

    return result.isSuccess;*/


    final url = Uri.parse('http://134.122.67.190:5000/updateQuestion');

    //POST /updateQuestion

    //application/json
    var result = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode(question.data.toMap()));

    if (result.statusCode == 200) {
      if(jsonDecode(result.body)['success'] == false) {
        throw Exception('Failed to update question');
      }
    } else {
      throw Exception(jsonDecode(result.body));
    }

    return true;
  }
}
