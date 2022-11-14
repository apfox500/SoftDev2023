import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'background.dart';
import 'bottom_buttons.dart';
import 'global.dart';
import 'home.dart';
import 'lesson.dart';
import 'question.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage(this.global, this.question, {Key? key}) : super(key: key);
  final Global global;
  final Question question;
  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    Global global = widget.global;
    List<Widget> options = widget.question.generateOptions(context, global);
    return Scaffold(
      bottomNavigationBar: FooterButtons(
        global,
        page: "question",
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: backgroundDecoration(context),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .01,
                    ),
                    Text(
                      widget.question.question,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .1,
                    ),
                  ] +
                  options + //Actually add in the options based on the type of question
                  [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            int currentPlace = global.masterOrder[widget.question.section]!
                                    .indexOf(widget.question) -
                                1;
                            global.currentPlace[widget.question.section] = currentPlace;

                            Widget page = HomePage(global);
                            if (global.masterOrder[widget.question.section]![currentPlace]
                                is Question) {
                              page = QuestionPage(
                                  global, global.masterOrder[widget.question.section]![currentPlace]);
                            } else if (global.masterOrder[widget.question.section]![currentPlace]
                                is Lesson) {
                              page = LessonPage(
                                  global, global.masterOrder[widget.question.section]![currentPlace]);
                            }

                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.leftToRight,
                                fullscreenDialog: true,
                                child: page,
                              ),
                            );
                          },
                          child: Text("Go back"),
                        ),
                        Visibility(
                          visible: widget.question.type !=
                              QuestionType
                                  .matching, //hide if it is matching, probably also multiple choice
                          child: ElevatedButton(
                            onPressed: () {
                              widget.question.seen = true;
                              //TODO: figure out how to move on to question(like difficulty, number of, etc.)
                              // for now I will use the masterOrder list
                              int currentPlace = global.currentPlace[widget.question.section]!;
                              global.currentPlace[widget.question.section] = currentPlace + 1;
                              currentPlace = global.currentPlace[widget.question.section]!;

                              Widget page = HomePage(global);
                              try {
                                if (global.masterOrder[widget.question.section]![currentPlace]
                                    is Question) {
                                  page = QuestionPage(global,
                                      global.masterOrder[widget.question.section]![currentPlace]);
                                } else if (global.masterOrder[widget.question.section]![currentPlace]
                                    is Lesson) {
                                  page = LessonPage(global,
                                      global.masterOrder[widget.question.section]![currentPlace]);
                                }
                              } catch (_) {}
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: page,
                                  type: PageTransitionType.rightToLeft,
                                ),
                              );
                            },
                            child: const Text("Submit"),
                          ),
                        ),
                      ],
                    ),
                  ],
            ),
          ),
        ),
      ),
    );
  }
}
