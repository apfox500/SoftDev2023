import 'lesson.dart';

class Global {
  //This is where all global variables will go bc flutter isn't really supposed to have globals
  //TODO: put rest of sections into here
  Map<String, List<Lesson>> lessons = {
    "syntax": [],
    "data types": [],
  }; //section: [lessons]
  //For now imma hard code in a lesson and some questions
  Global() {
    lessons["data types"]!.add(
      Lesson(
        0,
        "data types",
        true,
        ["int", "float", "str", "bool"],
        "Introduction to Data Types",
        """In python there are 4 basic data types:\n
       - Integers(called 'int') which are positive or negative whole numbers\n 
       - Floats(called 'float') which are positive or negative deicmal numbers\n 
       - String(called 'str') which are usually text, words, and sentences surronded by quotes\n
       - Booleans(called 'bool') which are either true or false\n
       \n
       With these 4 basic data types you can do most of the basics of coding, and you need to be able to tell them apart and know when to use them""",
      ),
    );
  }
}
