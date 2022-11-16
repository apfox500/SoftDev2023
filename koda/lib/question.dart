import 'dart:math';

import 'package:flutter/material.dart';

import 'drag_and_drop.dart';
import 'global.dart';
import 'lesson.dart';

//TODO: actual code type of question
class Question extends Comparable {
  final Section section;
  final List<String> goal;
  final double? lesson;
  late String identity; //Uniuqe identifier for every question

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
    this.lesson = -1,
  }) {
    //TODO: figure out how to assign indenties to questions
    //for now I'm thining "lesson number(-1 if not).intro difficulty.inter difficulty.section.3 digit random number"
    //fyi, the ?? checks if its not null, if it is then the other thing will be passed(-1 in this instance)
    identity = "${lesson ?? -1}.$introDiff.$interDiff.$section.${Random().nextInt(1000)}";
  }

  List<List<dynamic>> generateOptions(BuildContext context, Global global) {
    List<List<dynamic>> ret = [
      [],
    ]; //[[options], [choices], [selected]]
    if (type == QuestionType.multiple || type == QuestionType.select) {
      //TODO: make multiple choice pretty
      //randomize the order
      multipleOptions!.shuffle();
      //Map every string into a Text() widget to pass to the MultipleChoice widget
      List<Text> textWidgets = multipleOptions!.map((e) => Text(e)).toList();
      List<bool> selected = List.filled(textWidgets.length, false);
      ret[0].add(
        MultipleChoice(
          global,
          textWidgets: textWidgets,
          selected: selected,
          select: type == QuestionType.select,
        ),
      );
      ret.add(multipleOptions!);
      ret.add(selected);
    } else if (type == QuestionType.matching) {
      ret[0].add(DragNDrop(this, global)); //I made it its own thing bc gee whiz was it massive
    } else if (type == QuestionType.short) {
      //TODO: short answer
      //Probably will involve textField() and be done in like 5 seconds I believe in you9please say I'm not talking to myself here

    }

    return ret; //[[options], [choices], [selected]]
  }

  Question setMatching(Map<String, String> matchingOptions) {
    this.matchingOptions = matchingOptions;
    return this;
  }

  Question setMultiple(
      List<String> multipleOptions, List<String> correctQs, Map<String, String> explanations) {
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
}

class MultipleChoice extends StatefulWidget {
  const MultipleChoice(
    this.global, {
    Key? key,
    required this.textWidgets,
    required this.selected,
    this.select = false,
  }) : super(key: key);
  final Global global;
  final List<Text> textWidgets;
  final List<bool> selected;
  final bool select;

  @override
  State<MultipleChoice> createState() => _MultipleChoiceState();
}

class _MultipleChoiceState extends State<MultipleChoice> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: widget.selected,
      direction: Axis.vertical,
      renderBorder: false,
      //borderRadius: BorderRadius.circular(10),//warning: looks v. ugly

      onPressed: (index) {
        if (!widget.select) {
          //the move here is to loop thorugh and change whats selected
          for (int i = 0; i < widget.selected.length; i++) {
            widget.selected[i] = i == index;
          }
        } else {
          widget.selected[index] = !widget.selected[index];
        }
        setState(() {});
      },
      children: widget.textWidgets,
    );
  }
}

enum QuestionType {
  multiple,
  select,
  matching,
  short,
  code,
} //NOTE - code is experimental and as of rn is unuseable

enum Section {
  syntax,
  dataTypes,
  arithmetic,
  variables,
  commonFunctions,
  errors,
  comparisonOperators,
  ifs,
  loops,
  reference,
  functions,
  classes,
}

QuestionType findType(String type) {
  if (type == "Matching") {
    return QuestionType.matching;
  } else if (type == "Multiple Choice") {
    return QuestionType.multiple;
  } else if (type == "Short Answer") {
    return QuestionType.short;
  } else if (type == "Multiple Select") {
    return QuestionType.select;
  } else {
    return QuestionType.code;
  }
}

Section findSection(String section) {
  if (section == "syntax") {
    return Section.syntax;
  } else if (section == "data types") {
    return Section.dataTypes;
  } else if (section == "arthmetic operators") {
    return Section.arithmetic;
  } else if (section == "variables") {
    return Section.variables;
  } else if (section == "common functions") {
    return Section.commonFunctions;
  } else if (section == "errors") {
    return Section.errors;
  } else if (section == "comparison operators") {
    return Section.comparisonOperators;
  } else if (section == "ifs") {
    return Section.ifs;
  } else if (section == "loops") {
    return Section.loops;
  } else if (section == "reference") {
    return Section.reference;
  } else if (section == "functions") {
    return Section.functions;
  } else {
    return Section.classes;
  }
}
