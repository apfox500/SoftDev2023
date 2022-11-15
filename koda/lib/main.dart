import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:koda/global.dart';
import 'package:koda/question.dart';

import 'home.dart';

//TODO: create a page with a python editor/console on it so they can actually code in app
void main() async {
  //TODO: add in loading and timer while syncing lessons
  //Possibly use a future builder inside the app instead
  //instantiate our global variable
  Global global = Global();
  await getDataFromGoogleSheet(global);
  runApp(MyApp(global));
}

class MyApp extends StatelessWidget {
  const MyApp(this.global, {Key? key}) : super(key: key);
  final Global global;
  @override
  Widget build(BuildContext context) {
    //Some hard coded lessons and questions for now
    /* Lesson lesson1 = Lesson(
      number: 0,
      section: Section.dataTypes,
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
      section: Section.dataTypes,
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
            section: Section.dataTypes,
            goal: ["str"],
            introDiff: 2,
            interDiff: 1,
            type: QuestionType.multiple,
            question: "Which is the correct way to declare a String(str)?")
        .setMultiple(
      ['"Hello World"', 'Hello World', '"Hello" "World"', '("Hello World")'],
      ['"Hello World"'],
      {
        '("Hello World")':
            'While the quotes are correct, parenthese aren\'t needed for strings so "Hello World" is a better choice'
      },
    );
    global.lessons[Section.dataTypes]!.add(lesson1);
    global.questions[Section.dataTypes]!.add(question1);
    global.masterOrder[Section.dataTypes] = [lesson1, question1, question2]; */

    //TODO: import data from the google sheet

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

//Function to load in data from the google sheet
Future<void> getDataFromGoogleSheet(Global global) async {
  //loads in a [JSON, JSON] for our questions
  Response data = await http.get(
    Uri.parse(
        "https://script.google.com/macros/s/AKfycbyilCKFOfiGLoQlDJ8FTgfYjcOcvUCBSwBEdBxho2CYpp88wTNNymfFMdrWI_wAJqGI/exec"),
  );
  dynamic jsonAppData = convert.jsonDecode(data.body);
  for (dynamic data in jsonAppData) {
    //seperate difficulties
    double bothDiffs = data['difficulty'].toDouble();
    int introDiff = bothDiffs.truncate();
    int interDiff = ((bothDiffs - introDiff) * 10 + 1)
        .toInt(); //gets the decimal part of it plus 1(shifts from the 0-9 to a 1-10 scale)
    //find type and section
    QuestionType type = findType(data['type']);
    Section section = findSection(data['section']);
    //lesson pairing
    int? lesson;
    if (data['lesson'] != "") lesson = int.parse(data['lesson']);

    //load in generic data
    Question question = Question(
      section: section,
      goal: data['goals'].toString().split(", ").toList(),
      introDiff: introDiff,
      interDiff: interDiff,
      type: type,
      question: data['question'],
      lesson: lesson,
    );
    //load in answers based off of type
    if (type == QuestionType.multiple || type == QuestionType.select) {
      //multiple choice
      List<String> correctLettters = (data['correct'] as String).split(",");
      List<String> options = [];
      List<String> correctQs = [];
      Map<String, String> explanations = {};
      List<String> letters = List.generate(
        8,
        (index) => String.fromCharCode(
          "A".codeUnitAt(0) + index,
        ),
      ); //Fancy way to generate an 8 letter list
      for (String letter in letters) {
        //loop through all 8 possible letters
        String option = data[letter];

        if (option != "") {
          //only do stuff if it isn't empty
          options.add(option); //add to options
          if (correctLettters.contains(letter)) correctQs.add(option); //add to correct if it is right
          String explain = data["exp$letter"];
          if (explain != "") explanations[option] = explain; //only add an explanation if one exists
        }
      }
      question.setMultiple(options, correctQs, explanations);
    } else if (type == QuestionType.matching) {
      //matching
      List<String> termLetters = List.generate(
        4,
        (index) => String.fromCharCode(
          "A".codeUnitAt(0) + index,
        ),
      ); //Fancy way to generate an 4 letter list
      List<String> defLetters = List.generate(
        4,
        (index) => String.fromCharCode(
          "E".codeUnitAt(0) + index,
        ),
      ); //Fancy way to generate an 4 letter list
      Map<String, String> pairs = {};
      for (int i = 0; i < termLetters.length; i++) {
        //loop through the 4 pairs and add them into the question
        pairs[data[termLetters[i]]] = data[defLetters[i]];
      }
      question.setMatching(pairs);
    } else if (type == QuestionType.short) {
      //short answer
      question.setShort(data['correct']);
    } else if (type == QuestionType.code) {
      //TODO: figure out how QuestionType.code will work
    }

    //add question to its respective location in global
    global.questions[question.section]!.add(question);
  }

  //and now the lessons
  //TODO: get the lessons from the google sheet

  //then order them
  //TODO figure out the master order list for now
  //I'm thinking it goes lesson number, any questions for it, lesson ....
  //Only problem is when do you ever get to do remedial?
  //possibly an algoritihim like add 2.5 to the actual lesson number and put it and its questions in there?
}
