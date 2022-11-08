import 'package:flutter/material.dart';

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
              children: [],
            ),
          ),
        ),
      ),
      bottomNavigationBar: FooterButtons(global),
    );
  }
}
