import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class BottomButton extends StatelessWidget {
  //This class makes the buttons so it isn't a bunch of repeated code
  const BottomButton({
    Key? key,
    required this.name,
    required this.pageWidget,
    required this.currentPage,
    required this.color,
    required this.icon,
  }) : super(key: key);

  final String name; //name of this button/page it goes to
  final Widget pageWidget; //widget that the button actually goes to(i.e. MyHomePage())
  final String currentPage; //page user is currently on
  final Color color; //theme color or color that the button will be
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        //this basially just makes sure that we aren't already on that page, and then itll send you
        if (currentPage != name) {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              fullscreenDialog: true,
              child: pageWidget,
            ),
          );
        }
      },
      icon: Icon(
        icon, //icon for the page
        color: (currentPage == name)
            ? color
            : null, //button will be the provided color when the user is on that page
      ),
      tooltip: name, //lil thing thats floats when you hover over it
    );
  }
}
