import 'question.dart';
import 'section.dart';

class Lesson extends Comparable {
  final double number;
  final Section section;
  //possibly remove original bc contained in number value?:
  final bool original; //Is it the first one viewed or the remediation one
  final List<String> goal;
  final String title;
  final String body;

  bool completed = false;

  Lesson({
    required this.number,
    required this.section,
    required this.original,
    required this.goal,
    required this.title,
    required this.body,
  });

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
        //for now I wieght redoing a lesson after 2 new ones
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
    if (number % 1 == 0) {
      //it is an original lesson
      thisWorkingNumber = number;
    } else {
      //It is a remedial lesson
      thisWorkingNumber = number + 2;
      //for now I weight redoing a lesson after 2 new ones
    }
    //return the difference
    return ((thisWorkingNumber - otherWorkingNumber) * 100).toInt();
    //multiply by 100 so we don't loose any decimals that could be hiding when we convert to int
  }

  @override
  String toString() {
    return "$section|$number|$original|$goal|$title";
  }
}
