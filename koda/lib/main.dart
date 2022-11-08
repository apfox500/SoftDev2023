import 'package:flutter/material.dart';
import 'package:koda/global.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //instantiate our global variable
    Global global = Global();
    //actually build the app
    return MaterialApp(
      theme: ThemeData(
        //light theme
        colorSchemeSeed: Colors.purple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        //dark theme
        colorSchemeSeed: Colors.purple,
        brightness: Brightness.dark,
      ),
      home: HomePage(global),
      debugShowCheckedModeBanner: false,
      //debugShowMaterialGrid: true,
    );
  }
}
