import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:koda/bottom_buttons.dart';

import 'background.dart';
import 'global.dart';

class Lesson {
  final double number;
  final String section;
  final bool original; //Is it the first one viewed or the remediation one
  final List<String> goal;
  final String title;
  final String body;
  bool completed = false;

  Lesson(
    this.number,
    this.section,
    this.original,
    this.goal,
    this.title,
    this.body,
  );
}

class LessonPage extends StatefulWidget {
  const LessonPage(this.global, this.lesson, {Key? key}) : super(key: key);
  final Global global;
  final Lesson lesson;
  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  @override
  Widget build(BuildContext context) {
    final Global global = widget.global;
    return Scaffold(
      bottomNavigationBar: FooterButtons(
        global,
        page: "lesson",
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: backgroundDecoration(context),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.lesson.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                Text(widget.lesson.body),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
