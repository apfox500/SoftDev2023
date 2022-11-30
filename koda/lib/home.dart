import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'background.dart';
import 'bottom_buttons.dart';
import 'global.dart';
import 'lesson.dart';
import 'lesson_page.dart';
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
    Future<Map<Section, bool>> unlocked = global.userUpdate();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Global.davysGrey,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: FutureBuilder<Map<Section, bool>>(
              future: unlocked,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Section> unlockedSections =
                      global.masterOrder.keys.toList().where((element) => global.unlocked[element]!).toList();
                  return ListView.builder(
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
                        child: ListTile(
                          tileColor: Global.coolGrey,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                10,
                              ),
                            ),
                          ),
                          onTap: () {
                            if (progress < 1) {
                              int currentPlace = global.currentPlace[unlockedSections[index]]!;

                              Widget page = HomePage(global);
                              try {
                                if (global.masterOrder[unlockedSections[index]]![currentPlace] is Question) {
                                  page = QuestionPage(
                                      global, global.masterOrder[unlockedSections[index]]![currentPlace]);
                                } else if (global.masterOrder[unlockedSections[index]]![currentPlace] is Lesson) {
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
                          title: Text(global.sectionNames[unlockedSections[index]]!),
                          subtitle: Text('Progress: ${(progress * 100).round()}%'),
                        ),
                      );
                    }),
                  );
                } else {
                  return const CircularProgressIndicator(); //lil baby loading screen while we get user specific data
                }
              }),
        ),
      ),
      bottomNavigationBar: FooterButtons(global),
    );
  }
}
