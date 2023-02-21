import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'dart:convert' as convert;
import '../models/global.dart';
import '../utilities/lesson.dart';
import '../utilities/question.dart';
import '../utilities/question_type.dart';
import '../utilities/section.dart';

///loads in data about lessons and questions from the google sheet
Future<void> getDataFromGoogleSheet(Global global) async {
  //loads in a [JSON, JSON] for our questions
  Response data = await http.get(
    Uri.parse(
        "https://script.google.com/macros/s/AKfycbxoqWQFiB6fVNItzBvv_LBSQoVX2Jh-TXOMdUc1CCYZtXxopQo8sna3GFOG4JBrwlYr/exec"),
  );
  dynamic jsonAppData = convert.jsonDecode(data.body);

  //go through all of the questions
  try {
    for (dynamic data in jsonAppData[0]) {
      //seperate difficulties
      double bothDiffs = double.parse(data['difficulty'].toString());
      int introDiff = bothDiffs.truncate();
      //gets the decimal part of it plus 1(shifts from the 0-9 to a 1-10 scale)
      int interDiff = ((bothDiffs - introDiff) * 10 + 1).toInt();
      //find type and section
      QuestionType type = findType(data['type']);
      Section section = findSection(data['section']);
      //lesson pairing
      double? lesson;
      if (data['lesson'] != "")
        lesson = double.parse(data['lesson'].toString());

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
        List<String> correctLetters = (data['correct'] as String).split(", ");
        List<String> options = [];
        List<String> correctQs = [];
        Map<String, String> explanations = {};
        //Fancy way to generate an 8 letter list
        List<String> letters = List.generate(
            8, (index) => String.fromCharCode("A".codeUnitAt(0) + index));
        for (String letter in letters) {
          //loop through all 8 possible letters
          String option = data[letter].toString();

          if (option != "") {
            //only do stuff if it isn't empty
            options.add(option); //add to options
            if (correctLetters.contains(letter))
              correctQs.add(option); //add to correct if it is right
            String explain = data["exp$letter"];
            if (explain != "")
              explanations[option] =
                  explain; //only add an explanation if one exists
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
  } on Exception catch (e) {
    // ignore: avoid_print
    print(e);
  }

  //and now the lessons
  try {
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
  } on Exception catch (e) {
    // ignore: avoid_print
    print(e);
  }

  //then order them
  //For now we use master order list
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
    //then sort the list
    holder.sort(
      ((a, b) {
        return a.compareTo(b);
      }),
    );
    //print(holder);
    global.masterOrder[section] = holder;
  });
}
