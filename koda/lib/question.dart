import 'dart:math';

import 'package:flutter/material.dart';

import 'background.dart';
import 'bottom_buttons.dart';
import 'global.dart';

class Question {
  final String section;
  final List<String> goal;
  final int? lesson;
  late String identity; //Uniuqe identifier for every question

  final int introDiff; //Scale of 1-10
  final int interDiff; //scale of 1-10
  //Either choice(multiple choice), select(Multiple select), matching, or short(Short answer)
  final String type;
  final String question;

  //For use in multiple chioice and multiple select
  Map<String, String>? multipleOptions; //"Letter":"Actual text"
  List<String>? correctQs; //list of all right answers
  Map<String, String>? explanations; //"Letter":"explanation"

  String? shortAnswer; //for short answer

  List<Map<String, String>>? matchingOptions; //["term":"defintion"], probably 4 entries in each

  //User data abt this, may be stored elsewhere
  bool seen = false; //has the user seen this before?
  double? passrate;

  Question({
    required this.section,
    required this.goal,
    required this.introDiff,
    required this.interDiff,
    required this.type,
    required this.question,
    this.lesson = -1,
  }) {
    //TODO: figure out how to assign indenties to questions
    //for now I'm thining "lesson number(-1 if not).intro difficulty.inter difficulty.section.3 digit random number"
    //fyi, the ?? checks if its not null, if it is then the other thing will be passed(-1 in this instance)
    identity = "${lesson ?? -1}.$introDiff.$interDiff.$section.${Random().nextInt(1000)}";
  }

  //TODO: figure out a way for how to assign the options/answers depending on the question type

  List<Widget> generateOptions() {
    List<Widget> ret = [];
    if (type.toLowerCase() == "multiple") {
      //Locate the correct answer before we randomize
      String correctText = multipleOptions![correctQs![0]]!;
      //Get the values(aka options)
      List<String> values = multipleOptions!.values.toList();
      //randomize the order
      values.shuffle();
      //Go through each element and create a selector for it
      for (String option in values) {
        //TODO: actually create multiple choice options

      }
    } else if (type.toLowerCase() == "select") {
      //TODO: multiple select

    } else if (type.toLowerCase() == "matching") {
      //TODO: matching
      //Probably using draggables

    } else if (type.toLowerCase() == "short") {
      //TODO: short answer
      //Probably will involve textField()

    }

    return ret;
  }

  //TODO: copy this for the other types
  Question setMatching(List<Map<String, String>> matchingOptions) {
    this.matchingOptions = matchingOptions;
    return this;
  }
}

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
    List<Widget> options = widget.question.generateOptions();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                    Text(
                      widget.question.question,
                      style: Theme.of(context).textTheme.headline6,
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
                            //will have to change to actually going to a lesson if there are multiple questions follwoing a lesson
                            Navigator.pop(context);
                          },
                          child: Text("Go back to lesson"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            //TODO: figure out how to grade and then move on
                          },
                          child: const Text("Submit"),
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
