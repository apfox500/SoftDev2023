import 'package:flutter/material.dart';
import 'package:koda/bottom_buttons.dart';
import 'package:koda/home.dart';
import 'package:koda/question.dart';
import 'package:page_transition/page_transition.dart';

import 'background.dart';
import 'global.dart';
import 'question_page.dart';

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
    return ((otherWorkingNumber - thisWorkingNumber) * 100).toInt();
    //multiply by 100 so we don't loose any decimals that could be hiding when we convert to int
  }
}

class LessonPage extends StatefulWidget {
  const LessonPage(this.global, this.lesson, {Key? key}) : super(key: key);
  final Global global;
  final Lesson lesson;
  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  @override
  Widget build(BuildContext context) {
    final Global global = widget.global;
    return Scaffold(
      bottomNavigationBar: FooterButtons(
        global,
        page: "lesson",
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: backgroundDecoration(context),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Text(
                  widget.lesson.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(widget.lesson.body),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () {
                      //TODO: figure out how to move on to question(like difficulty, number of, etc.)
                      // for now I will use the masterOrder list
                      int currentPlace = global.currentPlace[widget.lesson.section]!;
                      global.currentPlace[widget.lesson.section] = currentPlace + 1;
                      currentPlace = global.currentPlace[widget.lesson.section]!;

                      Widget page = HomePage(global);
                      try {
                        if (global.masterOrder[widget.lesson.section]![currentPlace] is Question) {
                          page = QuestionPage(
                              global, global.masterOrder[widget.lesson.section]![currentPlace]);
                        } else if (global.masterOrder[widget.lesson.section]![currentPlace]
                            is Lesson) {
                          page = LessonPage(
                              global, global.masterOrder[widget.lesson.section]![currentPlace]);
                        }
                      } catch (_) {}

                      Navigator.push(
                        context,
                        PageTransition(
                          child: page,
                          type: PageTransitionType.fade,
                        ),
                      );
                    },
                    child: const Text("Go to Questions"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
