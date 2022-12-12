import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'lesson.dart';
import 'question.dart';

//TODO: make these comments the way they are supposed to be
class Global {
  //Static/copnstant variables we want to be global
  static Map<Section, String> sectionNames = {
    Section.syntax: "Python Basics: Syntax",
    Section.dataTypes: "Python Basics: Data Types",
    Section.arithmetic: "Python Basics: Artimetic Operators",
    Section.variables: "Python Basics: Variables",
    Section.commonFunctions: "Python Basics: Common Functions",
    Section.errors: "Getting Into Python: Some Common Errors",
    Section.comparisonOperators: "Getting Into Python: Comparison Operators",
    Section.ifs: "Intermediate Python: If/Elif/Else",
    Section.loops: "Intermediate Python: Loops",
    Section.reference: "Advanced Python: Object Reference",
    Section.functions: "Advanced Python: Making your own functions",
    Section.classes: "Master Python: Making your own classes",
  }; //Section:expanded section name that can actually be displayed
  //TODO: add in more of these messages
  static List<String> failedMessages = ["Better luck next time", "This close... lets try again"];
  static List<String> passedMessages = ["Congratulations", "Knew you were smart!"];
  static List<String> continueMessages = ["Move on", "Continue", "Keep Going"];

  //This is where all global variables will go bc flutter isn't really supposed to have globals
  Map<Section, List<Lesson>> lessons = {}; //section: [lessons]

  Map<Section, List<Question>> questions = {}; //section:[questions]
  //TODO: create an algorithim for lessons rather than just hard code - Andrew has a voicenote with
  ///his plan of how to do it, tlak to him or let him do it
  //for now i will just be hardcoding in a plan, but it should be dynamic based on whether they pass questions, what theyve seen etc.
  Map<Section, List<dynamic>> masterOrder =
      {}; //section:[lesson1, question 1.1, question 1.2, lesson 2, question 2.1 ...]

  //TODO: rn everything is like one class(intro and intermediate are combined), and they could
  ///techincally start anywhere, so we will need to figure out if there is intro/inter mediate or how
  ///to unlock sections etc.

  //Universal Firebase stuff
  List<AuthProvider<AuthListener, AuthCredential>> providers = [EmailAuthProvider()];

  //user specific data stuff
  Map<Section, bool> unlocked = {}; //have they unlocked the section?
  User? user;
  Map<Section, int> currentPlace = {}; //Section: index of lesson or question
  Set<Question> seenQuestions = {}; //here:[Question], in firestore: Question.toString-+-timesSeen-+-timesPassed
  Set<Lesson> seenLessons = {}; //here:[Lesson], in firestore: Lesson as a string-+-completed
  int questionGoal = 15; //number of question they want to reach every day
  Map<String, int> questionDailyHistory = {}; //day(MM-DD-YY format): how many questions they did that day
  List<Question> priority = []; //The list of priority questions to display before continuing on with masterOrder
  Lesson? priorityLesson;
  static Color jet = const Color.fromARGB(255, 45, 45, 42);
  static Color davysGrey = const Color.fromARGB(255, 76, 76, 71);
  static Color coolGrey = const Color.fromARGB(255, 132, 143, 165);
  static Color bittersweetShimmer = const Color.fromARGB(255, 193, 73, 83);
  static Color bone = const Color.fromARGB(255, 229, 220, 197);

  Global({required this.user}) {
    for (Section section in Section.values) {
      lessons[section] = [];
      questions[section] = [];
      masterOrder[section] = [];
      currentPlace[section] = 0;
      if (section == Section.arithmetic) {}
      unlocked[section] = false; //defaults to no unlocked sections

    }
  }

  Future<Map<Section, bool>> userUpdate() async {
    //This function pulls in all of the data from the database for the user
    //It will get: current progress, unlocked, historic passrates and seen questions

    CollectionReference db = FirebaseFirestore.instance.collection("Users");
    if (user != null) {
      await db.doc(user!.uid).get().then((DocumentSnapshot doc) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          //this actually gets what the user has seen
          currentPlace = (data["currentPlace"] as Map<String, dynamic>)
              .map((key, value) => MapEntry(Section.values.byName(key), value as int));
          unlocked = (data["unlocked"] as Map<String, dynamic>)
              .map((key, value) => MapEntry(Section.values.byName(key), value as bool));
          questionGoal = data["questionGoal"];
          questionDailyHistory =
              (data["dailyHistory"] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as int));

          //update seen questions
          for (dynamic question in (data["seenQuestions"] ?? []) as List<dynamic>) {
            List<dynamic> questionFormatted =
                question.toString().split("-+-"); //Question.toString-+-timesSeen-+-timesPassed
            List<String> indentifiers = questionFormatted[0].toString().split("|");
            //[section, ... ]
            Section section = Section.values.byName(indentifiers[0]);
            Question realQuestion = questions[section]!
                .firstWhere((element) => element.toString() == questionFormatted[0].toString());

            //finally update the values
            realQuestion.timesSeen = int.parse(questionFormatted[1].toString());
            realQuestion.timesPassed = int.parse(questionFormatted[2].toString());
            seenQuestions.add(realQuestion);
          }

          //update seen lessons
          for (dynamic lesson in (data["lessons"] ?? []) as List<dynamic>) {
            List<dynamic> lessonFormatted = lesson.toString().split("-+-"); //Lesson as a string-+-completed
            List<String> indentifiers = lessonFormatted[0].toString().split("|");
            //[section, lesson#, ... ]
            Section section = Section.values.byName(indentifiers[0]);
            Lesson realLesson =
                lessons[section]!.firstWhere((element) => element.toString() == lessonFormatted.toString());

            //finally update values
            realLesson.completed = (lessonFormatted[0].toString() == "true");
            seenLessons.add(realLesson);
          }
        } else {
          //document doesn't exist, so rn we will create an empty one
          //we know they are a new user so imma go ahead and unlock datatypes for them
          unlocked[Section.dataTypes] = true;
          db.doc(user!.uid).set({
            "currentPlace": currentPlace.map((key, value) => MapEntry(key.toString(), value)),
            "unlocked": unlocked.map((key, value) => MapEntry(key.name, value)),
            "seenQuestions": [],
            "seenLessons": [],
            "questionGoal": questionGoal,
            "dailyHistory": {},
          });
        }
      });
    }

    //in the end we return our unlocked(this is for the future building on the home page)
    return unlocked;
  }

  ///This function syncs all of the users data into the cloud
  ///
  ///Uses the .update because if we don't have to overwrite we dont want to obviously
  Future<void> syncUserData() async {
    //TODO implement syncing user data
    CollectionReference db = FirebaseFirestore.instance.collection("Users");
    if (user != null) {
      List<String> formattedSeenQuestions =
          seenQuestions.map((e) => "$e-+-${e.timesSeen}-+-${e.timesPassed}").toList();
      List<String> formattedSeenLessons = seenLessons.map((e) => "$e-+-${e.completed}").toList();
      await db.doc(user!.uid).update({
        "currentPlace": currentPlace.map((key, value) => MapEntry(key.toString(), value)),
        "unlocked": unlocked.map((key, value) => MapEntry(key.name, value)),
        "seenQuestions": formattedSeenQuestions,
        "seenLessons": formattedSeenLessons,
        "questionGoal": questionGoal,
        "dailyHistory": questionDailyHistory,
      });
    }
  }

  ///reset everything to blank so there is no risk of carryover data from other users
  void signout() {
    user = null;
    for (Section section in Section.values) {
      currentPlace[section] = 0;
      unlocked[section] = false; //defaults to no unlocked sections
      for (Question question in seenQuestions) {
        //delete all possible question data
        question.timesSeen = 0;
        question.timesPassed = 0;
      }
      seenQuestions = {};
      for (Lesson lesson in seenLessons) {
        //delete all possible lesson data
        lesson.completed = false;
      }
      seenLessons = {};
    }
  }
}
