import 'dart:math';

import '../models/global.dart';
import 'question.dart';
import 'section.dart';

List<Question> generateRandomQuestions(Global global) {
  List<Question> questions = [];
  Map<Section, List<Question>> allQuestions = global.questions;
  int numQuestions = 15;

  while (questions.length < numQuestions) {
    // Pick a random section
    Section section = allQuestions.keys.elementAt(Random().nextInt(allQuestions.keys.length));
    // calculate the pass rate of the section
    double passRate = 0;
    int seenCount = 0;
    int passedCount = 0;
    for (Question q in allQuestions[section]!) {
      seenCount += q.timesSeen;
      passedCount += q.timesPassed;
    }
    passRate = seenCount == 0 ? 0 : passedCount / seenCount;
    // Calculate the weight of the section based on its pass rate
    double weight = 1 - passRate;
    // Use the weight to adjust the probability of choosing this section
    if (Random().nextDouble() > weight) {
      continue;
    }
    // Pick a random question from the section
    List<Question> sectionQuestions = allQuestions[section]!;
    Question question = sectionQuestions[Random().nextInt(sectionQuestions.length)];
    // Adjust the probability of choosing a question based on its difficulty
    double difficulty = (question.introDiff + question.interDiff) / 20;
    if (Random().nextDouble() > difficulty) {
      continue;
    }
    questions.add(question);
  }
  return questions;
}

void createPriority(Global global) {
  if (global.priority.isNotEmpty) {
    throw Exception("global.priority must be empty when using createPriority");
  }
  //empty the priorities out
  global.priority = [];
  global.priorityLesson = null;
  //actually make them
  global.priority = generateRandomQuestions(global);
}

//TODO: create algorithim to decide when to create priority list
bool needPriority(Global global) {
  return false;
}
