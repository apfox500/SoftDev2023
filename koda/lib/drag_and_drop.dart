import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'global.dart';
import 'home.dart';
import 'lesson.dart';
import 'question.dart';
import 'question_page.dart';

class DragNDrop extends StatefulWidget {
  DragNDrop(this.question, this.global, {Key? key}) : super(key: key) {
    done = false;
  }
  final Question question;
  late bool done;
  final Global global;
  @override
  State<DragNDrop> createState() => _DragNDropState();
}

class _DragNDropState extends State<DragNDrop> {
  List<Draggable> terms = [];
  List<Widget> definitions = [];

  void generate() {
    Map<String, String> matchingOptions = widget.question.matchingOptions!;

    matchingOptions.forEach((term, definition) {
      //loop through each and add them to the lists

      //starting with the term
      double wigHeight = 35;
      //This is the widget that actually hold text ifyk
      Widget wig = Container(
        height: wigHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).colorScheme.onBackground,
            width: .5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            term,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      );
      terms.add(
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
      definitions.add(
        DragTarget(
          key: defKey,
          builder: (BuildContext context, List<Object?> _, List<dynamic> __) {
            return Container(
              height: wigHeight,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onBackground,
                    width: .5,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.onPrimary,
                      Theme.of(context).colorScheme.onPrimary.withRed(10)
                    ],
                  )),
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
            //TODO: figure out what to do when it actually lines
            if (data == term) {
              //They were right
              print("right");
              terms.remove(terms.firstWhere((Draggable element) => element.data == data));
              definitions.remove(
                  definitions.firstWhere((Widget element) => (element as DragTarget).key == defKey));
              if (definitions.isEmpty) {
                widget.done = true;
              }
              setState(() {});
            } else {
              //They were wrong
              print("wrong");
            }
          },
        ),
      );
    });
    //randomize the order
    terms.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    Global global = widget.global;
    if (definitions.isEmpty && !widget.done) generate();
    if (widget.done) {
      //TODO: figure out what to do now that they are done
    }
    return Column(
      children: (widget.done)
          ? [
              const Text("You did it!!"),
              const SizedBox(height: 15), //Padding

              ElevatedButton(
                onPressed: () {
                  widget.question.timesSeen++;
                  //TODO: figure out how to move on to question(like difficulty, number of, etc.)
                  // for now I will use the masterOrder list
                  int currentPlace = global.currentPlace[widget.question.section]!;
                  global.currentPlace[widget.question.section] = currentPlace + 1;
                  currentPlace = global.currentPlace[widget.question.section]!;

                  Widget page = HomePage(global);
                  try {
                    if (global.masterOrder[widget.question.section]![currentPlace] is Question) {
                      page = QuestionPage(
                          global, global.masterOrder[widget.question.section]![currentPlace]);
                    } else if (global.masterOrder[widget.question.section]![currentPlace] is Lesson) {
                      page = LessonPage(
                          global, global.masterOrder[widget.question.section]![currentPlace]);
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
                child: const Text("Continue"),
              ),
            ]
          : [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: terms,
              ),
              const SizedBox(height: 15), //Padding
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: definitions,
                ),
              ),
            ],
    );
  }
}
