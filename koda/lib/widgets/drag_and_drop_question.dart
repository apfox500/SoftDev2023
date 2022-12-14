import 'package:flutter/material.dart';

import '../models/global.dart';
import '../utilities/question.dart';
import '../utilities/message_type.dart';

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
                color: Global.jet,
              ),
            ],
            color: Global.bone),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
          child: Text(
            term,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
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
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: Global.davysGrey,
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
    if (!done && _terms.isEmpty) _generate(); //fill the list if we have no widgets and aren't done yet
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
              width: MediaQuery.of(context).size.width * .9,
              decoration:
                  BoxDecoration(color: Global.jet.withOpacity(.5), borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
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
            //Definitions
            Container(
              width: MediaQuery.of(context).size.width * .9,
              decoration:
                  BoxDecoration(color: Global.jet.withOpacity(.5), borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
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
