import 'package:koda/question.dart';
import 'lesson.dart';

class Global {
  //This is where all global variables will go bc flutter isn't really supposed to have globals
  //TODO: put rest of sections into these
  Map<String, List<Lesson>> lessons = {
    "syntax": [],
    "data types": [],
  }; //section: [lessons]
  Map<String, List<Question>> questions = {
    "syntax": [],
    "data types": [],
  }; //section:[questions]
  //TODO: create an algorithm for lessons rather than just hard code
  //for now i will just be hardocidng in a plan, but it should be dynamic based on whether they pass questinos, what theyve seen etc.
  Map<String, List<dynamic>> masterOrder = {
    "syntax": [],
    "data types": [],
  }; //section:[lesson1, question 1.1, question 1.2, lesson 2, question 2.1 ...]
  Map<String, int> currentPlace = {
    "syntax": 0,
    "data types": 0,
  }; //Section: index of lesson or question
  Map<String, String> sectionNames = {
    "syntax": "Python Basics: Syntax",
    "data types": "Python Basics: Data Types",
  }; //Section:expanded section name that can actually be displayed
  //TODO: rn everything is like one class(inro and intermediate are combined), and they could
  ///techincally start anywhere, so we will need to figure out if there is intro/inter mediate or how
  ///to unlick sections etc.

  //For now imma hard code in a lesson and some questions
  Global();
}
