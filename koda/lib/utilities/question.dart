import 'lesson.dart';
import 'question_type.dart';
import 'section.dart';

class Question extends Comparable {
  final Section section;
  final List<String> goal;
  final double? lesson;

  final int introDiff; //Scale of 1-10
  final int interDiff; //scale of 1-10
  final QuestionType type; //made an enum QuestionType
  final String question;

  //For use in multiple chioice and multiple select
  List<String>? multipleOptions; //[answer1, answer2, etc.]
  List<String>? correctQs; //list of all right answers
  Map<String, String>? explanations; //"Actual text":"explanation"

//for short answer
  String? shortAnswer;

//for use in matching
  Map<String, String>? matchingOptions; //"term":"defintion", probably 4 entries in each

  //User data abt this, may be stored elsewhere
  int timesSeen = 0; //how many times has the user seen this before?
  int timesPassed = 0;

  Question({
    required this.section,
    required this.goal,
    required this.introDiff,
    required this.interDiff,
    required this.type,
    required this.question,
    this.lesson,
  });

  Question setMatching(Map<String, String> matchingOptions) {
    this.matchingOptions = matchingOptions;
    return this;
  }

  Question setMultiple(List<String> multipleOptions, List<String> correctQs, Map<String, String> explanations) {
    this.multipleOptions = multipleOptions;
    this.correctQs = correctQs;
    this.explanations = explanations;

    return this;
  }

  Question setShort(String shortAnswer) {
    this.shortAnswer = shortAnswer;
    return this;
  }

  @override
  int compareTo(other) {
    double otherWorkingNumber = 0;
    double thisWorkingNumber = 0;
    //find working number
    if (other is Lesson) {
      if (other.number % 1 == 0) {
        //it is an original lesson
        otherWorkingNumber = other.number;
      } else {
        //It is a remedial lesson
        otherWorkingNumber = other.number + 2;
        //for now I weight redoing a lesson after 2 new ones
      }
    } else if (other is Question) {
      if (other.lesson! % 1 == 0) {
        //Its an original lesson question
        otherWorkingNumber = other.lesson! + .1;
        //add .1 onto questions because then they follow lessons
      } else {
        //Its a remedial lesson question
        otherWorkingNumber = other.lesson! + 2.1;
        //2 for remedial, .1 for question
      }
    }

    //then find this number
    if (lesson! % 1 == 0) {
      //it is an original lesson
      thisWorkingNumber = lesson! + .1;
      //.1 for question
    } else {
      //It is a remedial lesson
      thisWorkingNumber = lesson! + 2.1;
      //for now I weight redoing a lesson after 2 new ones, .1 for question
    }
    //return the difference
    return ((thisWorkingNumber - otherWorkingNumber) * 100).toInt();
    //multiply by 100 so we don't loose any decimals that could be hiding when we convert to int
  }

  @override
  String toString() {
    return "$section|$goal|$lesson|$introDiff|$interDiff|$type|$question";
  }
}


/*
 * For coding questions
 * I want it to be be drag and drop or dropdown menus or smt
 * so not hard code but structured so they can still make what they want, but then we can easily convert to dart and run it locally here
 * 
 * can use the eval(function)
 * force the user to specify the type of variable bc then not only can we use it, but they can learn it
 */

