import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'lesson.dart';
import 'question.dart';

class Global {
  //This is where all global variables will go bc flutter isn't really supposed to have globals
  Map<Section, List<Lesson>> lessons = {}; //section: [lessons]

  Map<Section, List<Question>> questions = {}; //section:[questions]
  //TODO: create an algorithim for lessons rather than just hard code
  //for now i will just be hardcoding in a plan, but it should be dynamic based on whether they pass questions, what theyve seen etc.
  Map<Section, List<dynamic>> masterOrder =
      {}; //section:[lesson1, question 1.1, question 1.2, lesson 2, question 2.1 ...]
  Map<Section, int> currentPlace = {
    Section.syntax: 0,
    Section.dataTypes: 0,
    Section.loops: 0,
  }; //Section: index of lesson or question
  Map<Section, String> sectionNames = {
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
  //TODO: rn everything is like one class(intro and intermediate are combined), and they could
  ///techincally start anywhere, so we will need to figure out if there is intro/inter mediate or how
  ///to unlock sections etc.

  //user stuff
  List<AuthProvider<AuthListener, AuthCredential>> providers = [EmailAuthProvider()];
  Map<Section, bool> unlocked = {}; //have they onlocked the section?

  Global() {
    for (Section section in Section.values) {
      lessons[section] = [];
      questions[section] = [];
      masterOrder[section] = [];
      currentPlace[section] = 0;
      unlocked[section] = false; //defaults to no unlocked sections
    }
  }

  Future<void> userUpdate(User user) async {
    //This function pulls in all of the data from the database for the user
    //TODO: implement userUpdate
  }
}
