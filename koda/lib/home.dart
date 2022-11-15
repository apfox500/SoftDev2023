import 'package:flutter/material.dart';
import 'package:koda/lesson.dart';
import 'package:page_transition/page_transition.dart';

import 'background.dart';
import 'bottom_buttons.dart';
import 'global.dart';
import 'question.dart';
import 'question_page.dart';

class HomePage extends StatefulWidget {
  const HomePage(this.global, {Key? key}) : super(key: key);
  final Global global;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Global global = widget.global; //so we don't have to type widget.global everytime
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: backgroundDecoration(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ListView.builder(
              //Using a listview here to geerate a start for every section that exists
              itemCount: global.masterOrder.keys.toList().length,
              itemBuilder: ((context, index) {
                List<String> keys = global.masterOrder.keys.toList();
                double progress = 0;
                if (global.masterOrder[keys[index]]!.isNotEmpty) {
                  progress =
                      (global.currentPlace[keys[index]]!) / global.masterOrder[keys[index]]!.length;
                } else {}

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () {
                      if (progress < 1) {
                        int currentPlace = global.currentPlace[keys[index]]!;

                        Widget page = HomePage(global);
                        try {
                          if (global.masterOrder[keys[index]]![currentPlace] is Question) {
                            page =
                                QuestionPage(global, global.masterOrder[keys[index]]![currentPlace]);
                          } else if (global.masterOrder[keys[index]]![currentPlace] is Lesson) {
                            page = LessonPage(global, global.masterOrder[keys[index]]![currentPlace]);
                          }
                        } catch (_) {}

                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            fullscreenDialog: true,
                            child: page,
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Text(global.sectionNames[
                              keys[index]]!), //TODO: this will need to be changed to dynamic
                          Text('Progress: ${(progress * 100).round()}%'),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
      bottomNavigationBar: FooterButtons(global),
    );
  }
}
