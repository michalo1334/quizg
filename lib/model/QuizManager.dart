import 'package:mongo_dart/mongo_dart.dart' as mongo;

import 'Question/Question.dart';
import 'Quiz.dart';

class QuizManager {

  QuizManager._privateConstructor();

  static const String connectionString = "mongodb://quiz:quiz123@134.122.67.190:27017/Quiz?authSource=admin";
  static const String databaseName = "quiz";
  static const String collectionName = "questions";

  static final QuizManager instance = QuizManager._privateConstructor();


  Future<List<String>> subjects() async {
    var db = mongo.Db(connectionString);
    await db.open();
    var collection = db.collection(collectionName);

    // Distinict by subject
    var result = List<String>.from((await collection.distinct("subject"))["values"]);

    db.close();

    return result;
  }

  Future<List<Question>> questionsBySubject(String subject) async {
    var db = mongo.Db(connectionString);
    await db.open();
    var collection = db.collection(collectionName);

    var questions = await collection.find(mongo.where.eq("subject", subject)).toList();
    return questions.map((e) => Question.fromMap(e)).toList();
  }

  Future<Map<String, Quiz>> quizesBySubject(String subject) async {
    var db = mongo.Db(connectionString);
    await db.open();
    var collection = db.collection(collectionName);

    // Query the database for questions by subject
    var questionsCursor = await collection.find({'subject': subject}).toList();

    // Close the database connection
    await db.close();

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
}