import 'package:flutter/material.dart';
import 'package:koda/bottom_buttons.dart';

import 'background.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple, brightness: Brightness.light),
      darkTheme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.dark,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      //debugShowMaterialGrid: true,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
/*                 GestureDetector(
                  child: Container(
                    child: Center(
                      child: Text("Hello World"),
                    ),
                    width: 150.0,
                    height: 150.0,
                    decoration: new BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ), */
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const FooterButtons(),
    );
  }
}
