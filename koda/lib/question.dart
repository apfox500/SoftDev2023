import 'package:collection/collection.dart';

import 'package:flutter/material.dart';

import 'global.dart';
import 'lesson.dart';

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

enum QuestionType {
  multiple,
  select,
  matching,
  short,
  code, //NOTE - code is experimental and as of rn is unuseable
}

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
  classes;

  @override
  String toString() => name;
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

///Builds a Widget specifically for Multiple Choice questions
class MultipleChoiceQuestion extends StatefulWidget {
  final Question question;
  final void Function() passed;
  final void Function() failed;

  const MultipleChoiceQuestion({super.key, required this.question, required this.passed, required this.failed});

  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  bool _isCorrect = false;
  String? answer;

  void _checkAnswer(String answer) {
    setState(() {
      this.answer = answer;
      _isCorrect = widget.question.correctQs!.contains(answer);
      showCorrectSnackBar(context, _isCorrect);
      if (!_isCorrect) {
        widget.failed();
      } else {
        widget.passed();
      }
    });
  }

  Widget _buildQuestion() {
    return Text(
      widget.question.question,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget _buildOptions() {
    return Column(
      children: widget.question.multipleOptions!.map((option) {
        return RadioListTile<String>(
          title: Text(
            option,
          ),
          value: option,
          groupValue: answer,
          onChanged: (value) => _checkAnswer(value!),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildQuestion(),
        _buildOptions(),
      ],
    );
  }
}

///Builds a Widget specifically for Multiple Select questions
class MultipleSelectQuestion extends StatefulWidget {
  final Question question;
  final void Function() passed;
  final void Function() failed;

  const MultipleSelectQuestion({super.key, required this.question, required this.passed, required this.failed});

  @override
  State<MultipleSelectQuestion> createState() => _MultipleSelectQuestionState();
}

class _MultipleSelectQuestionState extends State<MultipleSelectQuestion> {
  final Set<String> _selectedOptions = {};
  bool _isCorrect = false;

  void _checkAnswer() {
    setState(() {
      _isCorrect = const IterableEquality().equals(_selectedOptions, widget.question.correctQs!.toSet());
      showCorrectSnackBar(context, _isCorrect);
      if (_isCorrect) {
        widget.passed();
      } else {
        widget.failed();
      }
    });
  }

  Widget _buildOption(String option) {
    return CheckboxListTile(
      title: Text(option),
      value: _selectedOptions.contains(option),
      onChanged: (value) {
        setState(() {
          if (value!) {
            _selectedOptions.add(option);
          } else {
            _selectedOptions.remove(option);
          }
        });
      },
    );
  }

  Widget _buildExplanation() {
    if (!_isCorrect) {
      return Container();
    }

    return Column(
      children: widget.question.correctQs!.map((correctAnswer) {
        String? explanation = widget.question.explanations![correctAnswer];

        return Text(
          '$correctAnswer: $explanation',
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.question.question,
          style: Theme.of(context).textTheme.headline5,
        ),
        Column(
          children: widget.question.multipleOptions!.map(_buildOption).toList(),
        ),
        ElevatedButton(
          onPressed: _checkAnswer,
          child: const Text('Check Answer'),
        ),
        _buildExplanation(),
      ],
    );
  }
}

///Builds a Widget specifically for Drag and Drop(Matching) Questions
class DragAndDropQuestion extends StatefulWidget {
  final Question question;
  final void Function() passed;
  const DragAndDropQuestion({super.key, required this.question, required this.passed});

  @override
  State<DragAndDropQuestion> createState() => _DragAndDropQuestionState();
}

class _DragAndDropQuestionState extends State<DragAndDropQuestion> {
  late Map<String, String> _matchingOptions;
  final List<Draggable> _terms = [];
  final List<Widget> _definitions = [];
  late bool done;

  @override
  void initState() {
    super.initState();
    _matchingOptions = Map.from(widget.question.matchingOptions!);
    done = false;
  }

  ///Fills the [_terms] and [_definitions] lists with thier appropriate widgets
  void _generate() {
    //TODO: try putting the wig as a drag target so then anything can drag onto anything?
    _matchingOptions.forEach((term, definition) {
      //loop through each and add them to the lists

      //starting with the term
      double wigHeight = 35;
      //This is the widget that actually hold text ifyk
      Widget wig = Container(
        height: wigHeight,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: Global.bone,
              ),
            ],
            color: Global.coolGrey),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            term,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Theme.of(context).colorScheme.background,
                ),
          ),
        ),
      );
      _terms.add(
        Draggable(
          feedback: wig,
          childWhenDragging: SizedBox(
            height: wigHeight,
          ),
          data: term,
          child: wig,
        ),
      );

      //Then the definition
      Key defKey = Key(definition);
      _definitions.add(
        DragTarget(
          key: defKey,
          builder: (BuildContext context, List<Object?> _, List<dynamic> __) {
            return Container(
              height: wigHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).colorScheme.onPrimary,
                    Theme.of(context).colorScheme.onPrimary.withRed(30)
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  definition,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            );
          },
          onAccept: (String data) {
            //TODO: make this perty with sound and animation??
            if (data == term) {
              //They were right
              //print("right");
              _terms.remove(_terms.firstWhere((Draggable element) => element.data == data));
              _definitions
                  .remove(_definitions.firstWhere((Widget element) => (element as DragTarget).key == defKey));
              if (_definitions.isEmpty) {
                done = true;
              }
              setState(() {});
              //it would play a sound if its really cool...
            } else {
              //They were wrong
              //What to do here... an animation and some vibration maybe?
              //maybe flash up an expalnation?
              //print("wrong");
            }
          },
        ),
      );
    });
    //randomize the order
    _terms.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    //fill the list if we have no widgets and aren't done yet
    if (_definitions.isEmpty && !done) _generate();
    if (done) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * .45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Global.getRandomMessage(MessageType.passed),
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ), //TODO add in some cute lil animation or smt bc aww the did it lets celebrate!!
            ElevatedButton(
              onPressed: () => widget.passed(),
              child: Text(
                Global.getRandomMessage(MessageType.cont),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height * .4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //Question itself
            Text(
              widget.question.question,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            //Terms
            Container(
              decoration:
                  BoxDecoration(color: Global.jet.withOpacity(.5), borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Drag These",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _terms,
                    ),
                  ],
                ),
              ),
            ),
            //
            //Definitions
            Container(
              decoration:
                  BoxDecoration(color: Global.jet.withOpacity(.5), borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _definitions,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Drag Here",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}

///Builds a Widget specifically for Short Answer Questions
class ShortAnswerQuestion extends StatelessWidget {
  const ShortAnswerQuestion({required this.question, super.key, required this.passed, required this.failed});
  final Question question;
  final void Function() passed;
  final void Function() failed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          question.question,
          style: Theme.of(context).textTheme.headline5,
        ),
        TextField(
          onSubmitted: (value) {
            if (value == question.shortAnswer) {
              showCorrectSnackBar(context, true);
              passed();
            } else {
              showCorrectSnackBar(context, false);
              failed();
            }
          },
        ),
      ],
    );
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

//TODO: make this better
void showCorrectSnackBar(BuildContext context, bool correct) {
  String ret = (correct) ? "Correct: " : "Incorrect: ";
  ret += "\n${Global.getRandomMessage((correct) ? MessageType.passed : MessageType.failed)}";
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        ret,
      ),
    ),
  );
}
