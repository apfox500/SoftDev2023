import 'package:flutter/material.dart';
import 'package:koda/utilities/algorithm.dart';

import '../../utilities/section.dart';
import '../../widgets/bottom_buttons.dart';
import '../../models/global.dart';

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
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "KODA",
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: "SpaceGrotesque",
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .8,
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<Map<Section, bool>>(
                    future: unlocked,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Section> unlockedSections = global.masterOrder.keys
                            .toList()
                            .where((element) => global.unlocked[element]!)
                            .toList();
                        return ListView.builder(
                          //Using a listview here to geerate a start for every section that they have unlocked
                          itemCount: unlockedSections.length,
                          itemBuilder: ((context, index) {
                            double progress = 0;
                            if (global.masterOrder[unlockedSections[index]]!.isNotEmpty) {
                              //this checks to make sure that there is in fact a masterOrder to use
                              progress = (global.currentPlace[unlockedSections[index]]!) /
                                  global.masterOrder[unlockedSections[index]]!.length;
                              //Then do the math to find how what percent they are at
                            }

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
                                    //only do smt if they haven't completed the section
                                    navigatePage(global, context, unlockedSections[index], forwards: false);
                                    /* int currentPlace = global.currentPlace[unlockedSections[index]]!;

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
                                    );*/
                                  }
                                },
                                //TODO: make a long tap where they can view all completed lessons, or quiz themselves, or reset their progress
                                ///I', thinking some kind of expansion widget? modal sheet could also work
                                title: Text(Global.sectionNames[unlockedSections[index]]!),
                                subtitle: Text('Progress: ${(progress * 100).round()}%'),
                              ),
                            );
                          }),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        ); //lil baby loading screen while we get user specific data
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: FooterButtons(global),
    );
  }
}
