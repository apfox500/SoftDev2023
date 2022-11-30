import 'package:flutter/material.dart';

import 'background.dart';
import 'bottom_buttons.dart';
import 'global.dart';

//TODO: are we still doing this? if so gotta start it and figure out what we want to do with it

class TranslatePage extends StatefulWidget {
  const TranslatePage(this.global, {Key? key}) : super(key: key);
  final Global global;
  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  @override
  Widget build(BuildContext context) {
    Global global = widget.global;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Global.davysGrey,
      body: const SafeArea(
        child: Center(),
      ),
      bottomNavigationBar: FooterButtons(
        global,
        page: "Translate",
      ),
    );
  }
}
