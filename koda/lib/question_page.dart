import 'package:flutter/material.dart';
import 'package:koda/algorithm.dart';
import 'package:page_transition/page_transition.dart';

import 'bottom_buttons.dart';
import 'global.dart';
import 'home.dart';
import 'lesson.dart';
import 'lesson_page.dart';
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
    List<List<dynamic>> optionsMaster =
        widget.question.generateOptions(context, global); //[[options], [choices], [selected]]
    List<Widget> options = optionsMaster[0].cast<Widget>();

    return Scaffold(
      bottomNavigationBar: FooterButtons(
        global,
        page: "question",
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        //decoration: backgroundDecoration(context),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                    SizedBox(height: MediaQuery.of(context).size.height * .01), //Padding
                    Text(
                      widget.question.question, //The question itself
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .1), //Padding
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
                            //stuff to go back
                            int currentPlace =
                                global.masterOrder[widget.question.section]!.indexOf(widget.question) - 1;
                            global.currentPlace[widget.question.section] = currentPlace;

                            Widget page = HomePage(global);
                            if (global.masterOrder[widget.question.section]![currentPlace] is Question) {
                              page = QuestionPage(
                                  global, global.masterOrder[widget.question.section]![currentPlace]);
                            } else if (global.masterOrder[widget.question.section]![currentPlace] is Lesson) {
                              page =
                                  LessonPage(global, global.masterOrder[widget.question.section]![currentPlace]);
                            }

                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.fade,
                                fullscreenDialog: true,
                                child: page,
                              ),
                            );
                          },
                          child: const Text("Go back"),
                        ),
                        Visibility(
                          visible: widget.question.type !=
                              QuestionType.matching, //hide if it is matching, probably also multiple choice
                          child: ElevatedButton(
                            onPressed: () {
                              bool passed = true;
                              List<String> neededExplains = [];
                              widget.question.timesSeen++;

                              //Grading the question
                              if (widget.question.type == QuestionType.short) {
                                //TODO: short answer grading
                              } else {
                                //This button is not available for matching, so this can only be choice and select
                                List<String> choices = optionsMaster[1].cast<String>();
                                List<bool> selected = optionsMaster[2].cast<bool>();
                                //Many ways you could grade this, I'm just creating a list of what
                                //selected should look like, and then if each value is correct they move on
                                List<bool> rightAnswers =
                                    choices.map((e) => widget.question.correctQs!.contains(e)).toList();
                                for (int i = 0; i < selected.length; i++) {
                                  if (selected[i] != rightAnswers[i]) {
                                    //They got something wrong
                                    passed = false;
                                    //if they selected a wrong answer we need to put why it was wrong
                                    if (selected[i]) {
                                      //this checks if we didn't offer an explanation, then the default is just saying it's wrong
                                      neededExplains.add(widget.question.explanations![choices[i]] ??
                                          "${choices[i]} is incorrect");
                                    }
                                  }
                                }
                                if (passed) {
                                  widget.question.timesPassed++;
                                  //TODO add in explanations for correct answers
                                } else {
                                  if (!selected.contains(true)) {
                                    //if they put nothing lets tell them that
                                    neededExplains.add(
                                        "C'mon, you gotta choose something...even if its a guess"); //TODO this guy should be random
                                  }
                                }
                              }

                              //Then show a dialog to tell them if they were right or not
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ResponseDialog(
                                      global: global,
                                      question: widget.question,
                                      passed: passed,
                                      explains: neededExplains,
                                    );
                                  });
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

class ResponseDialog extends StatelessWidget {
  const ResponseDialog({
    Key? key,
    required this.passed,
    required this.global,
    required this.question,
    required this.explains,
  }) : super(key: key);
  final bool passed;
  final Global global;
  final Question question;
  final List<String> explains;
  @override
  Widget build(BuildContext context) {
    if (passed) {
      return SimpleDialog(
        title: const Text("Congratulations"), //TODO: make this a bank of random responses
        children: [
          Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    navigatePage(global, context, question.section, question: question);
                    /* //Stuff to go to next page
                    int currentPlace = global.currentPlace[question.section]!;
                    global.currentPlace[question.section] = currentPlace + 1;
                    currentPlace = global.currentPlace[question.section]!;

                    //user stuff
                    question.timesSeen++;
                    question.timesPassed++;
                    global.seenQuestions.add(question);
                    global.syncUserData();

                    Widget page = HomePage(global);
                    try {
                      if (global.masterOrder[question.section]![currentPlace] is Question) {
                        page = QuestionPage(global, global.masterOrder[question.section]![currentPlace]);
                      } else if (global.masterOrder[question.section]![currentPlace] is Lesson) {
                        page = LessonPage(global, global.masterOrder[question.section]![currentPlace]);
                      }
                    } catch (_) {}
                    Navigator.push(
                      context,
                      PageTransition(
                        child: page,
                        type: PageTransitionType.fade,
                      ),
                    ); */
                  },
                  child: const Text("Continue"))
            ],
          ),
        ],
      );
    } else {
      return Center(
        child: SimpleDialog(
          title: const Text("Incorrect"), //TODO make this one random too
          children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Oh! you just missed the mark!"),
                ), //TODO: make this pick from a pool of random messages to make it more ...fun?
              ] +
              explains
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e),
                      ))
                  .toList() +
              <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          //TODO find closest lesson backwards from currentPosition and then go there
                        },
                        child: const Text("Back to lesson")),
                    ElevatedButton(
                      onPressed: () {
                        //Stuff to restart this page fresh
                        //TODO: update to navigatePage()
                        int currentPlace = global.currentPlace[question.section]!;

                        Widget page = QuestionPage(global, global.masterOrder[question.section]![currentPlace]);

                        Navigator.push(
                          context,
                          PageTransition(
                            child: page,
                            type: PageTransitionType.fade,
                          ),
                        );
                      },
                      child: const Text("Try again"),
                    ),
                  ],
                ),
              ],
        ),
      );
    }
  }
}
