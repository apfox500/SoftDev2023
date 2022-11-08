import 'package:flutter/material.dart';

import 'background.dart';
import 'bottom_buttons.dart';
import 'global.dart';

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
    double padding = 8;
    double titleHeight = MediaQuery.of(context).textScaleFactor * 20;
    double height = MediaQuery.of(context).size.height - buttonHeight - padding * 2 - titleHeight;
    double width = MediaQuery.of(context).size.width - padding * 2;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: backgroundDecoration(context),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Translate",
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 20),
                ),
                Container(
                  //pseudocode box?
                  width: width,
                  height: height / 2.1,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(15)),
                ),
                Container(
                  //code box?
                  width: width,
                  height: height / 2.1,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(15)),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: FooterButtons(
        global,
        page: "translate",
      ),
    );
  }
}
