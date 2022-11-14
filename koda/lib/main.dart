import 'package:flutter/material.dart';
import 'package:koda/global.dart';
import 'package:koda/question.dart';

import 'home.dart';
import 'lesson.dart';

//TODO: change sections to enums
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //instantiate our global variable
    Global global = Global();
    //Some hard coded lessons and questions for now
    Lesson lesson1 = Lesson(
      number: 0,
      section: "data types",
      original: true,
      goal: ["int", "float", "str", "bool"],
      title: "Introduction to Data Types",
      body: """In python there are 4 basic data types:\n
       - Integers(called 'int') which are positive or negative whole numbers\n 
       - Floats(called 'float') which are positive or negative deicmal numbers\n 
       - String(called 'str') which are usually text, words, and sentences surronded by quotes\n
       - Booleans(called 'bool') which are either true or false\n
       \n
       With these 4 basic data types you can do most of the basics of coding, and you need to be able to tell them apart and know when to use them""",
    );
    Question question1 = Question(
      section: "data types",
      goal: ["int", "float", "str", "bool"],
      introDiff: 2,
      interDiff: 1,
      type: QuestionType.matching,
      question: "Match the following to the correct data type",
      lesson: 0,
    ).setMatching(
      {"1.5": "float", "Hello": "str", "2": "int", "true": "bool"},
    );
    Question question2 = Question(
            section: "data types",
            goal: ["str"],
            introDiff: 2,
            interDiff: 1,
            type: QuestionType.multiple,
            question: "Which is the correct way to declare a String(str)?")
        .setMultiple(
      {"A": '"Hello World"', 'B': 'Hello World', 'C': '"Hello" "World"', 'D': '("Hello World")'},
      ["A"],
      {
        "D":
            'While the quotes are correct, parenthese aren\'t needed for strings so "Hello World" is a better choice'
      },
    );
    global.lessons["data types"]!.add(lesson1);
    global.questions["data types"]!.add(question1);
    global.masterOrder["data types"] = [lesson1, question1, question2];
    global.masterOrder["syntax"] = [
      lesson1
    ]; //I am aware this isnt a syntax lesson, but Its stopping the divide by zero error

    //actually build the app
    return MaterialApp(
      theme: ThemeData(
        //light theme
        colorSchemeSeed: Colors.purple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        //dark theme
        colorSchemeSeed: Colors.purple, //TODO: choose main color/color scheme for app
        brightness: Brightness.dark,
      ),
      home: HomePage(global),
      debugShowCheckedModeBanner: false,
      //debugShowMaterialGrid: true,
    );
  }
}
