import 'lesson.dart';
import 'question.dart';

class Global {
  //This is where all global variables will go bc flutter isn't really supposed to have globals
  //TODO: put rest of sections into these...with code?? in the constructor??
  Map<Section, List<Lesson>> lessons = {
    Section.syntax: [],
    Section.dataTypes: [],
  }; //section: [lessons]

  Map<Section, List<Question>> questions = {
    Section.syntax: [],
    Section.dataTypes: [],
  }; //section:[questions]
  //TODO: create an algorithim for lessons rather than just hard code
  //for now i will just be hardcoding in a plan, but it should be dynamic based on whether they pass questions, what theyve seen etc.
  Map<Section, List<dynamic>> masterOrder = {
    Section.syntax: [],
    Section.dataTypes: [],
  }; //section:[lesson1, question 1.1, question 1.2, lesson 2, question 2.1 ...]
  Map<Section, int> currentPlace = {
    Section.syntax: 0,
    Section.dataTypes: 0,
  }; //Section: index of lesson or question
  Map<Section, String> sectionNames = {
    Section.syntax: "Python Basics: Syntax",
    Section.dataTypes: "Python Basics: Data Types",
  }; //Section:expanded section name that can actually be displayed
  //TODO: rn everything is like one class(intro and intermediate are combined), and they could
  ///techincally start anywhere, so we will need to figure out if there is intro/inter mediate or how
  ///to unlock sections etc.

  Global();
}
