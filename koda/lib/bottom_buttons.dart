import "package:flutter/material.dart";
import 'package:koda/main.dart';
import 'package:koda/profile.dart';
import 'package:koda/translate.dart';
import 'package:page_transition/page_transition.dart';

double buttonHeight = 50;

class FooterButtons extends StatelessWidget {
  const FooterButtons({Key? key, this.page = "home"}) : super(key: key);
  final String page;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //translate page -- translate
          IconButton(
            onPressed: () {
              if (page != "translate") {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    fullscreenDialog: true,
                    child: const TranslatePage(),
                  ),
                );
              }
            },
            icon: Icon(
              Icons.translate,
              color: (page == "translate") ? Theme.of(context).colorScheme.primary : null,
            ),
            tooltip: "translate",
          ),
          //home page -- home
          IconButton(
            onPressed: () {
              if (page != "home") {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    fullscreenDialog: true,
                    child: const HomePage(),
                  ),
                );
              }
            },
            icon: Icon(
              Icons.home,
              color: (page == "home") ? Theme.of(context).colorScheme.primary : null,
            ),
            tooltip: "home",
          ),

//profile page -- proflie
          IconButton(
            onPressed: () {
              if (page != "profile") {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    fullscreenDialog: true,
                    child: const ProfilePage(),
                  ),
                );
              }
            },
            icon: Icon(
              Icons.person,
              color: (page == "profile") ? Theme.of(context).colorScheme.primary : null,
            ),
            tooltip: "profile",
          ),
        ],
      ),
    );
  }
}
