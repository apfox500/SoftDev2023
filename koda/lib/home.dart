import 'package:flutter/material.dart';
import 'package:koda/lesson.dart';
import 'package:page_transition/page_transition.dart';

import 'background.dart';
import 'bottom_buttons.dart';
import 'global.dart';

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
            child: Column(
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        fullscreenDialog: true,
                        child: LessonPage(
                          global,
                          global.lessons["data types"]![0],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: const [
                        Text(
                            'Python basics: Data Types'), //TODO: this will need to be changed to dynamic
                        Text('Progress: ${0}%'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: FooterButtons(global),
    );
  }
}
