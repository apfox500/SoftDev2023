import 'dart:math';

import 'package:flutter/material.dart';

import 'background.dart';
import 'bottom_buttons.dart';
import 'drag_and_drop.dart';
import 'global.dart';

class Question {
  final String section;
  final List<String> goal;
  final int? lesson;
  late String identity; //Uniuqe identifier for every question

  final int introDiff; //Scale of 1-10
  final int interDiff; //scale of 1-10
  //Either choice(multiple choice), select(Multiple select), matching, or short(Short answer)
  final QuestionType type;
  final String question;

  //For use in multiple chioice and multiple select
  Map<String, String>? multipleOptions; //"Letter":"Actual text"
  List<String>? correctQs; //list of all right answers
  Map<String, String>? explanations; //"Letter":"explanation"

//for short answer
  String? shortAnswer;

//for use in matching
  Map<String, String>? matchingOptions; //"term":"defintion", probably 4 entries in each

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

  List<Widget> generateOptions(BuildContext context, Global global) {
    List<Widget> ret = [];
    if (type == QuestionType.multiple) {
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
    } else if (type == QuestionType.select) {
      //TODO: multiple select
    } else if (type == QuestionType.matching) {
      ret.add(DragNDrop(this, global)); //I made it its own thing bc gee whiz was it massive
    } else if (type == QuestionType.short) {
      //TODO: short answer
      //Probably will involve textField()

    }

    return ret;
  }

  Question setMatching(Map<String, String> matchingOptions) {
    this.matchingOptions = matchingOptions;
    return this;
  }

  Question setMultiple(
      Map<String, String> multipleOptions, List<String> correctQs, Map<String, String> explanations) {
    this.multipleOptions = multipleOptions;
    this.correctQs = correctQs;
    this.explanations = explanations;

    return this;
  }

  Question setShort(String shortAnswer) {
    this.shortAnswer = shortAnswer;
    return this;
  }
}

enum QuestionType { multiple, select, matching, short }
