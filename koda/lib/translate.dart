import 'package:flutter/material.dart';

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

//Shitty prgram stolen from an AI
String translateToPseudocode(String pythonCode) {
  // Remove leading and trailing whitespace from the Python code
  pythonCode = pythonCode.trim();

  // Split the Python code into a list of lines
  List<String> lines = pythonCode.split('\n');

  // Initialize a string to hold the pseudocode
  String pseudocode = '';

  // Loop through each line of the Python code
  for (String line in lines) {
    // Remove leading and trailing whitespace from the line
    line = line.trim();

    // Skip empty lines
    if (line.isEmpty) {
      continue;
    }

    // Translate the Python code to pseudocode
    if (line.startsWith('def ')) {
      // Function definition
      pseudocode += 'FUNCTION ${line.substring(4)}';
    } else if (line.startsWith('if ')) {
      // If statement
      pseudocode += 'IF ${line.substring(3)} THEN';
    } else if (line.startsWith('else:')) {
      // Else statement
      pseudocode += 'ELSE';
    } else if (line.startsWith('for ')) {
      // For loop
      pseudocode += 'FOR ${line.substring(4)}';
    } else if (line.startsWith('while ')) {
      // While loop
      pseudocode += 'WHILE ${line.substring(6)}';
    } else if (line.endsWith(':')) {
      // Indentation
      pseudocode += '\t${line.substring(0, line.length - 1)}';
    } else {
      // Other lines
      pseudocode += line;
    }

    // Add a newline character to the end of the pseudocode
    pseudocode += '\n';
  }

  // Return the generated pseudocode
  return pseudocode;
}
