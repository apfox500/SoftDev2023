import 'package:flutter/material.dart';
import 'package:koda/utilities/navigation.dart';

import '../../widgets/footer_buttons.dart';
import '../../models/global.dart';
import '../../utilities/lesson.dart';

class LessonPage extends StatefulWidget {
  const LessonPage(this.global, this.lesson, {Key? key}) : super(key: key);
  final Global global;
  final Lesson lesson;
  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  late Global global;

  @override
  void initState() {
    global = widget.global;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FooterButtons(
        global,
        page: "lesson",
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Global.davysGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            //should let us scroll if there is a prticularly long lesson

            child: Column(
              children: [
                Text(
                  widget.lesson.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(widget.lesson.body),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () async {
                      navigatePage(global, context, widget.lesson.section, lesson: widget.lesson);
                      /* int currentPlace = global.currentPlace[widget.lesson.section]!;
                      global.currentPlace[widget.lesson.section] = currentPlace + 1;
                      currentPlace = global.currentPlace[widget.lesson.section]!;

                      //user stuff
                      widget.lesson.completed = true;
                      global.seenLessons.add(widget.lesson);
                      global.syncUserData();

                      //actually moving pages
                      Widget page = HomePage(global);
                      try {
                        if (global.masterOrder[widget.lesson.section]![currentPlace] is Question) {
                          page = QuestionPage(global, global.masterOrder[widget.lesson.section]![currentPlace]);
                        } else if (global.masterOrder[widget.lesson.section]![currentPlace] is Lesson) {
                          page = LessonPage(global, global.masterOrder[widget.lesson.section]![currentPlace]);
                        }
                      } catch (_) {}

                      Navigator.push(
                        context,
                        PageTransition(
                          child: page,
                          type: PageTransitionType.fade,
                        ),
                      ); */
                    },
                    child: const Text("Go to Questions"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
