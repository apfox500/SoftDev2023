import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'background.dart';
import 'bottom_buttons.dart';
import 'global.dart';
import 'lesson.dart';
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
    List<Section> unlockedSections =
        global.masterOrder.keys.toList().where((element) => global.unlocked[element]!).toList();
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
              //Using a listview here to geerate a start for every section that they have unlocked
              itemCount: unlockedSections.length,
              itemBuilder: ((context, index) {
                double progress = 0;
                if (global.masterOrder[unlockedSections[index]]!.isNotEmpty) {
                  progress = (global.currentPlace[unlockedSections[index]]!) /
                      global.masterOrder[unlockedSections[index]]!.length;
                } else {}

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () {
                      if (progress < 1) {
                        int currentPlace = global.currentPlace[unlockedSections[index]]!;

                        Widget page = HomePage(global);
                        try {
                          if (global.masterOrder[unlockedSections[index]]![currentPlace]
                              is Question) {
                            page = QuestionPage(
                                global, global.masterOrder[unlockedSections[index]]![currentPlace]);
                          } else if (global.masterOrder[unlockedSections[index]]![currentPlace]
                              is Lesson) {
                            page = LessonPage(
                                global, global.masterOrder[unlockedSections[index]]![currentPlace]);
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
                          Text(global.sectionNames[unlockedSections[index]]!),
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
