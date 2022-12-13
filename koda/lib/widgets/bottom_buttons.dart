import "package:flutter/material.dart";
import 'package:koda/screens/common/profile.dart';
import 'package:koda/screens/common/translate.dart';
import 'package:page_transition/page_transition.dart';

import '../models/global.dart';
import '../screens/common/home.dart';

double buttonHeight = 50;

class FooterButtons extends StatelessWidget {
  const FooterButtons(this.global, {Key? key, this.page = "Home"}) : super(key: key);
  final Global global;
  final String page; //page that currently on
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Global.jet,
      height: buttonHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //Translate
          Button(
            name: "Translate",
            pageWidget: TranslatePage(global),
            currentPage: page,
            color: Theme.of(context).colorScheme.primary,
            icon: Icons.code, //TODO: better icon here
          ),
          //home page -- Home
          Button(
            name: "Home",
            pageWidget: HomePage(global),
            currentPage: page,
            color: Theme.of(context).colorScheme.primary,
            icon: Icons.home,
          ),
          //Profile page
          Button(
            name: "Profile",
            pageWidget: ProfilePage(global),
            currentPage: page,
            color: Theme.of(context).colorScheme.primary,
            icon: Icons.person,
          )
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  //This class makes the buttons so it isn't a bunch of repeated code
  const Button({
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
