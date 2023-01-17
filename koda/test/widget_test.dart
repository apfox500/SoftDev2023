// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:koda/models/global.dart';

import 'package:koda/main.dart';
import 'package:koda/utilities/priority.dart';
import 'package:koda/utilities/question.dart';
import 'package:koda/utilities/question_type.dart';
import 'package:koda/utilities/section.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(Global(user: null)));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    testGenerateRandomQuestions();
  });
}

void testGenerateRandomQuestions() {
  // Create a mock Global object with sample data
  Global global = Global(user: null);
  Map<Section, List<Question>> questions = {
    Section.syntax: [],
    Section.dataTypes: [],
    Section.arithmetic: [],
  };
  // Create sample questions
  for (int i = 1; i <= 9; i++) {
    Section section;
    String question = "Question $i";
    String correctQ;
    String explanation;
    String shortAnswer;
    Map<String, String> matchingOptions;
    List<String> multipleOptions = [];
    List<String> correctQs = [];
    Map<String, String> explanations = {};
    int introDiff = i % 3 + 1;
    int interDiff = (i + 1) % 3 + 1;

    if (i <= 3) {
      section = Section.syntax;
      correctQ = "Option 1";
      explanation = "Explanation $i";
      multipleOptions = ["Option 1", "Option 2", "Option 3"];
      correctQs = ["Option 1"];
      explanations = {
        "Option 1": "Explanation $i",
        "Option 2": "Explanation ${i + 1}",
        "Option 3": "Explanation ${i + 2}"
      };
    } else if (i <= 6) {
      section = Section.dataTypes;
      correctQ = "Option 2";
      explanation = "Explanation ${i + 2}";
      multipleOptions = ["Option 1", "Option 2", "Option 3"];
      correctQs = ["Option 2"];
      explanations = {
        "Option 1": "Explanation ${i + 3}",
        "Option 2": "Explanation ${i + 4}",
        "Option 3": "Explanation ${i + 5}"
      };
    } else {
      section = Section.arithmetic;
      correctQ = "Option 1";
      explanation = "Explanation ${i + 5}";
      multipleOptions = ["Option 1", "Option 2", "Option 3"];
      correctQs = ["Option 1"];
      explanations = {
        "Option 1": "Explanation ${i + 6}",
        "Option 2": "Explanation ${i + 7}",
        "Option 3": "Explanation ${i + 8}"
      };
    }

    Question questionQ = Question(
      section: section,
      goal: ["goal$i"],
      introDiff: introDiff,
      interDiff: interDiff,
      type: QuestionType.multiple,
      question: question,
    );
    questionQ.setMultiple(multipleOptions, correctQs, explanations);
    questions[section]!.add(questionQ);
  }
  global.questions = questions;

  // Call the generateRandomQuestions function
  List<Question> randomQuestions = generateRandomQuestions(global);

  // Print the questions to the console to check the result
  for (var question in randomQuestions) {
    print(question.question);
  }
}
