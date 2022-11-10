import 'package:koda/question.dart';

import 'lesson.dart';

class Global {
  //This is where all global variables will go bc flutter isn't really supposed to have globals
  //TODO: put rest of sections into here
  Map<String, List<Lesson>> lessons = {
    "syntax": [],
    "data types": [],
  }; //section: [lessons]
  Map<String, List<Question>> questions = {
    "syntax": [],
    "data types": [],
  }; //section:[questions]
  //For now imma hard code in a lesson and some questions
  Global() {
    lessons["data types"]!.add(
      Lesson(
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
      ),
    );
    questions["data types"]!.add(
      Question(
        section: "data types",
        goal: ["int", "float", "str", "bool"],
        introDiff: 1,
        interDiff: 1,
        type: "matching",
        question: "Match the following to the correct data type",
        lesson: 0,
      ).setMatching(
        [
          {"1.0": "float"},
          {"Hello": "str"},
          {"-2": "int"},
          {"true": "bool"},
        ],
      ),
    );
  }
}
