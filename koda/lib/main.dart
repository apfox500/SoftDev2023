import 'dart:convert' as convert;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'firebase_options.dart';
import 'global.dart';
import 'home.dart';
import 'lesson.dart';
import 'question.dart';

//TODO: create a page with a python editor/console on it so they can actually code in app
//TODO: setup profiles to keep and track progress as well as control settings
//TODO: that one page where you take a picture of code and it translates to psuedocode/enlgish
//TODO: use routes instead of .push for the main pages(i think idk if its actually supposed to happen)
void main() async {
  runApp(
    const Center(
      child: CircularProgressIndicator(),
    ),
  );
  //TODO: add in timer while syncing lessons
  ///Possibly use a future builder inside the app instead
  /////initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  User? user = FirebaseAuth.instance.currentUser;
  //instantiate our global variable
  Global global = Global(user: user);
  //get lesson plans
  await getDataFromGoogleSheet(global);

  //profile stuff here for now
  if (user != null) {
    await global.userUpdate();
  }

  //open real app
  runApp(MyApp(global));
}

class MyApp extends StatelessWidget {
  const MyApp(this.global, {Key? key}) : super(key: key);
  final Global global;

  @override
  Widget build(BuildContext context) {
    //for now I will unlock some sections, but once user update is working it should be removed
    //TODO: remove
    global.unlocked[Section.dataTypes] = true;
    global.unlocked[Section.arithmetic] = true;

    //actually build the app
    return MaterialApp(
      theme: ThemeData(
        //light theme
        colorSchemeSeed: Colors.purple, //currently this is big uggo
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        //dark theme
        colorSchemeSeed: Colors
            .purple, //TODO: choose main color/color scheme for app, apparently I suck at ui so someone else go!
        brightness: Brightness.dark,
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? '/sign-in'
          : '/home', //this way, only signed in users can use the app
      debugShowCheckedModeBanner: false,
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            providers: global.providers,
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.pushReplacementNamed(context, '/home');
              }),
            ],
          );
        },
        '/home': (context) {
          return HomePage(global);
        }
      },
      //debugShowMaterialGrid: true,
    );
  }
}

//Function to load in data from the google sheet
Future<void> getDataFromGoogleSheet(Global global) async {
  //TODO wrap in a try catch so errors in the google sheet wont fuck us over
  //loads in a [JSON, JSON] for our questions
  Response data = await http.get(
    Uri.parse(
        "https://script.google.com/macros/s/AKfycbxoqWQFiB6fVNItzBvv_LBSQoVX2Jh-TXOMdUc1CCYZtXxopQo8sna3GFOG4JBrwlYr/exec"),
  );
  dynamic jsonAppData = convert.jsonDecode(data.body);
  //go through all of the questions
  for (dynamic data in jsonAppData[0]) {
    //seperate difficulties
    double bothDiffs = double.parse(data['difficulty'].toString());
    int introDiff = bothDiffs.truncate();
    int interDiff = ((bothDiffs - introDiff) * 10 + 1)
        .toInt(); //gets the decimal part of it plus 1(shifts from the 0-9 to a 1-10 scale)
    //find type and section
    QuestionType type = findType(data['type']);
    Section section = findSection(data['section']);
    //lesson pairing
    double? lesson;
    if (data['lesson'] != "") lesson = double.parse(data['lesson'].toString());

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
  for (dynamic data in jsonAppData[1]) {
    Lesson lesson = Lesson(
      number: double.parse(data['number'].toString()),
      section: findSection(data['section']),
      original: data['type'] == "original",
      goal: (data['goals'] as String).split(", "),
      title: data['title'],
      body: data['body'],
    );
    //then add it to global
    global.lessons[lesson.section]!.add(lesson);
  }

  //then order them
  //TODO figure out how we order lessons
  //For now we use master order list:
  //I'm thinking it goes lesson number, any questions for it, lesson ....
  //Only problem is when do you ever get to do remedial?
  //possibly an algoritihim like add 2.5 to the actual lesson number and put it and its questions in there?
  global.masterOrder.forEach((Section section, List<dynamic> value) {
    //first we add in all of our lessons, sorted by number
    List<Lesson> orgLessons = global.lessons[section]!
        .where((element) => element.number % 1 == 0)
        .toList(); //original lessons
    List<Lesson> remLessons = global.lessons[section]!
        .where((element) => element.number % 1 != 0)
        .toList(); //remediation lessons
    List<Question> questions = global.questions[section]!
        .where((element) => element.lesson != null)
        .toList(); //we only want questions paired with lessons in the master order

    List<dynamic> holder = [
      ...orgLessons,
      ...questions,
      ...remLessons,
    ]; //the ... is called the spread operator and it... does... something..?(i honestly have no clue but this line of code merges the lists while still sorting them)
    holder.sort(
      ((a, b) {
        return a.compareTo(b);
      }),
    );
    //print(holder);
    global.masterOrder[section] = holder;
  });
}
