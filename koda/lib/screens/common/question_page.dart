import 'package:flutter/material.dart';
import 'package:koda/utilities/algorithm.dart';

import '../../widgets/bottom_buttons.dart';
import '../../models/global.dart';
import '../../utilities/question.dart';
import '../../widgets/drag_and_drop_question.dart';
import '../../widgets/multiple_choice_question.dart';
import '../../widgets/multiple_select_question.dart';
import '../../widgets/short_answer_question.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage(this.global, this.question, {Key? key, this.passed, this.failed}) : super(key: key);
  final Global global;
  final Question question;
  final void Function()? passed;
  final void Function()? failed;
  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late void Function() passed;
  late void Function() failed;
  @override
  void initState() {
    super.initState();
    passed = widget.passed ?? defaultPassed;
    failed = widget.failed ?? defaultFailed;
  }

  ///The default function if someone completes a question, it saves their progress and moves them forward
  void defaultPassed() {
    widget.question.timesSeen++;
    widget.question.timesPassed++;
    widget.global.seenQuestions.add(widget.question);
    widget.global.syncUserData();
    navigatePage(
      widget.global,
      context,
      widget.question.section,
      question: widget.question,
    );
  }

  ///The default function if someone fails a question, it saves their progress and doesn't move them(resets the
  ///question)
  void defaultFailed() {
    widget.question.timesSeen++;
    widget.global.seenQuestions.add(widget.question);
    widget.global.syncUserData();
    navigatePage(
      widget.global,
      context,
      widget.question.section,
      question: widget.question,
      forwards: false,
    );
  }

  ///Returns the proper widget depending on this [question]'s [QuestionType]
  Widget _getQuestion(Question question) {
    if (question.type == QuestionType.multiple) {
      return MultipleChoiceQuestion(
        question: question,
        passed: passed,
        failed: failed,
      );
    } else if (question.type == QuestionType.select) {
      return MultipleSelectQuestion(
        question: question,
        passed: passed,
        failed: failed,
      );
    } else if (question.type == QuestionType.matching) {
      return DragAndDropQuestion(
        question: question,
        passed: passed,
      );
    } else if (question.type == QuestionType.short) {
      return ShortAnswerQuestion(
        question: question,
        passed: passed,
        failed: failed,
      );
    } else {
      return const Text("Uh oh\nSomeone Broke Me\n:.(");
    }
  }

  @override
  Widget build(BuildContext context) {
    Global global = widget.global;

    return Scaffold(
      bottomNavigationBar: FooterButtons(
        global,
        page: "question",
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Global.davysGrey,
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _getQuestion(widget.question),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => navigatePage(
                        global,
                        context,
                        widget.question.section,
                        forwards: false,
                        backwards: true,
                        question: widget.question,
                      ),
                      child: const Text("Go back"),
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

//Currently unused
/* class ResponseDialog extends StatelessWidget {
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
        title: Text(Global.getRandomMessage(MessageType.passed)),
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
                  child: Text(Global.getRandomMessage(MessageType.cont)))
            ],
          ),
        ],
      );
    } else {
      return Center(
        child: SimpleDialog(
          title: Text(Global.getRandomMessage(MessageType.failed)),
          children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(Global.getRandomMessage(MessageType.tryAgain)),
                ),
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
                          //TO-DO find closest lesson backwards from currentPosition and then go there
                        },
                        child: const Text("Back to lesson")),
                    ElevatedButton(
                      onPressed: () {
                        //Stuff to restart this page fresh
                        //TO-DO: update to navigatePage()
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
 */