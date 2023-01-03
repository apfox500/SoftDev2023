import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import '../utilities/lesson.dart';
import '../utilities/question.dart';
import '../utilities/message_type.dart';
import '../utilities/section.dart';

///Houses all global variables
///
///This class should only be created once when the app is opened, with a nun null [user] passed as the argument
///
///Static, or constant, variables include [sectionNames], [failedMessages], [passedMessages], [continueMessages],
///and the 5 colors for our app: [jet], [davysGrey], [coolGrey], [bittersweetShimmer], and [bone]
///
///
class Global {
  //Static/constant variables we want to be global:

  ///Maps the [Section] to a longer, fancy name
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
  };

  ///Messages to show when the user failed to pass a question
  static List<String> failedMessages = [
    "Better luck next time!",
    "Oh well, there's always a next time!",
    "Don't worry, it's not the end of the world!",
    "It's okay, everyone makes mistakes!",
    "It's not over until it's over!",
    "You'll get it next time!",
    "You're allowed to make mistakes!",
    "It's not a failure, it's a learning opportunity!",
    "It's not a setback, it's a challenge!",
    "It's not the end, it's a new beginning!",
    "It's not a loss, it's a valuable experience!",
    "You're not alone, we're all in this together!",
    "Keep your chin up and keep going!",
    "Don't let this discourage you, keep trying!",
    "Don't give up, you're almost there!",
    "Don't let this stop you, you can do it!",
    "You're better than this, show them what you're made of!",
    "You're capable of so much more, keep pushing yourself!",
    "You're stronger than you think, don't give up!",
    "You've got this, believe in yourself!",
    "You're not a failure, you're a success in the making!",
    "You're not done yet, there's more to come!",
    "This close... lets try again"
  ];

  ///Messages to show when the user passed a question
  static List<String> passedMessages = [
    "Congratulations",
    "Knew you were smart!",
    "Well done!",
    "You did it!",
    "Great job!",
    "Outstanding!",
    "Impressive!",
    "Marvelous!",
    "Fantastic!",
    "Huge congratulations!",
    "You deserve a pat on the back!",
    "You nailed it!",
    "I'm so proud of you!",
    "What an accomplishment!",
    "You should be very proud!",
    "You've earned this!",
    "You've worked hard for this!",
    "This is a huge achievement!",
    "You've made it happen!",
    "This is a fantastic result!",
    "You've exceeded expectations!",
    "You've set the bar high!",
    "You're on fire!",
    "This is just the beginning!",
    "You've got what it takes!",
    "You've shown your mettle!",
    "You've proven yourself!",
    "You've stood the test of time!",
    "You're a winner!",
    "You're a champion!",
    "You're a rockstar!",
    "You're a star!",
    "You're a superstar!",
    "You did it!",
    "Great job!",
    "You're amazing!",
    "You're a star!",
    "I'm so proud of you!",
    "You're a superstar!",
    "You're a winner!",
    "You're a champion!",
    "You're a rockstar!",
    "You're a force to be reckoned with!",
    "You're a shining example!",
    "You're a credit to your team!",
    "You're a valuable asset!",
    "You're a valuable member of the team!",
    "You're a valuable contributor!",
    "You're a valuable member of the community!",
    "You're an inspiration!",
    "You're an innovator!",
    "You're a trailblazer!",
    "You're a game-changer!",
    "You're a difference-maker!",
    "You're a driving force!",
    "You're a rising star!",
    "You're a shining star!",
    "You're a star on the rise!",
    "You're a shining example to us all!",
    "You're a beacon of light in a dark world!",
    "You're a light in the darkness!",
    "You're a shining light in a world of darkness!",
  ];

  ///Messages to show on buttons to go to next page with
  static List<String> continueMessages = [
    "Keep Going",
    "Go ahead!",
    "Next up!",
    "Onward!",
    "Forward!",
    "Advance!",
    "Proceed!",
    "Continue!",
    "Move on!",
    "Next step!",
    "Next stage!",
    "Next level!",
    "Next phase!",
    "Next stage!",
    "Next era!",
    "Next chapter!",
    "Next adventure!",
    "Next journey!",
    "Next quest!",
    "Next challenge!",
    "Next conquest!",
    "Next milestone!",
    "Next accomplishment!",
    "Next achievement!",
    "Next victory!",
    "Next success!",
    "Next triumph!",
    "Next success story!",
    "Next legend!",
    "Next page",
  ];

  ///Messages to show on buttons to try question again with
  static List<String> tryAgainMessages = [
    "Try again!",
    "Restart!",
    "Retry!",
    "Reset!",
    "Reboot!",
    "Redo!",
    "Repeat!",
    "Refresh!",
    "Replay!",
    "Re-enter!",
  ];

  ///Darker grey color - 45, 45, 42
  static Color jet = const Color.fromARGB(255, 45, 45, 42);

  ///lighter grey color - 76, 76, 71
  static Color davysGrey = const Color.fromARGB(255, 76, 76, 71);

  ///blue-grey color - 132, 143, 165
  static Color coolGrey = const Color.fromARGB(255, 132, 143, 165);

  ///pinkish-red color - 193, 73, 83
  static Color bittersweetShimmer = const Color.fromARGB(255, 193, 73, 83);

  ///off white color - 229, 220, 197
  static Color bone = const Color.fromARGB(255, 229, 220, 197);

  ///Firebase providers for this project
  ///
  ///Currently is just [EmailAuthProvider]
  static List<AuthProvider<AuthListener, AuthCredential>> providers = [EmailAuthProvider()];

  //Lesson and Question Stuff:

  ///Maps the [Section] to a [List] of all [Lesson] for that [Section]
  Map<Section, List<Lesson>> lessons = {};

  ///Maps the [Section] to a [List] of all [Question] for that [Section]
  Map<Section, List<Question>> questions = {};

  ///Maps the [Section] to a sorted [List] of all [Question] and [Lesson] for that [Section]
  ///
  ///Order is lesson, and its two following questions, then 2 lessons after that will appear the remedial with
  ///its questions
  ///Example: [l1, q1.1, q1.2, l2, q2.1, q2.2, l3, q3.1, q3.2, l1.5, q1.5.1, q1.5.2]
  Map<Section, List<dynamic>> masterOrder = {};

  //User specific data:

  ///Maps the [Section] to whether they have unlocked it
  ///
  ///[true] of they have, [false if they have not]
  Map<Section, bool> unlocked = {};

  ///[User] logged into the app via Firebase
  User? user;

  ///Maps the [Section] to the users index on [masterOrder] for each section
  Map<Section, int> currentPlace = {};

  ///[Set] of all [Question] the user has seen(interacted with) before
  ///
  ///Uses a [Set] rather than a [List] to avoid repeats
  ///
  ///here: [Question], in firestore: [Question.toString]-+-[timesSeen]-+-[timesPassed]
  Set<Question> seenQuestions = {};

  ///[Set] of all [Lesson] the user has seen(interacted with) before
  ///
  ///Uses a [Set] rather than a [List] to avoid repeats
  ///
  ///here: [Lesson], in firestore: [Lesson.toString]-+-[completed]
  Set<Lesson> seenLessons = {};

  ///Number of questions they want to reach every day
  ///
  ///default value is 15
  int questionGoal = 15;

  ///Maps a date in MM-DD-YY to how many [Question] they did that day
  Map<String, int> questionDailyHistory = {};

  ///The list of priority questions to display before continuing on with [masterOrder]
  List<Question> priority = [];

  ///[Lesson] related to priority
  ///
  ///If the person selected go back to question on their priority question, then that Lesson is stored here
  ///temporarily
  Lesson? priorityLesson;

  Global({required this.user}) {
    for (Section section in Section.values) {
      //set defaults
      lessons[section] = [];
      questions[section] = [];
      masterOrder[section] = [];
      currentPlace[section] = 0;
      if (section == Section.arithmetic) {}
      unlocked[section] = false;
    }
  }

  ///Pulls all data from the database for this [user]
  ///
  ///It will get: current progress, unlocked, historic passrates and seen questions, questionGoal, dailyHistory
  ///
  ///If the user has no existing data(they are new), a blank document will be created for them
  Future<Map<Section, bool>> userUpdate() async {
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

  ///resets everything to blank so there is no risk of carryover data from other users
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

  static String getRandomMessage(MessageType type) {
    if (type == MessageType.failed) {
      return failedMessages[Random().nextInt(failedMessages.length - 1)];
    } else if (type == MessageType.cont) {
      return continueMessages[Random().nextInt(continueMessages.length - 1)];
    } else if (type == MessageType.passed) {
      return passedMessages[Random().nextInt(passedMessages.length - 1)];
    } else if (type == MessageType.tryAgain) {
      return tryAgainMessages[Random().nextInt(tryAgainMessages.length - 1)];
    } else {
      return "Code got all fucky-wucky somewhere";
    }
  }
}
