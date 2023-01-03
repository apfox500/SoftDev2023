import "package:flutter/material.dart";
import 'package:koda/screens/common/ide_page.dart';
import 'package:koda/screens/common/profile.dart';
import 'package:koda/screens/common/translate.dart';
import '../models/global.dart';
import '../screens/common/home.dart';
import 'bottom_button.dart';

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
          BottomButton(
            name: "Translate",
            pageWidget: TranslatePage(global),
            currentPage: page,
            color: Theme.of(context).colorScheme.primary,
            icon: Icons.photo_camera, //TODO: better icon here
          ),
          //IDE
          BottomButton(
            name: "IDE",
            pageWidget: IDEPage(global),
            currentPage: page,
            color: Theme.of(context).colorScheme.primary,
            icon: Icons.code,
          ),
          //home page -- Home
          BottomButton(
            name: "Home",
            pageWidget: HomePage(global),
            currentPage: page,
            color: Theme.of(context).colorScheme.primary,
            icon: Icons.home,
          ),
          //Profile page
          BottomButton(
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
