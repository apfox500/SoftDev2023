//TODO: make this better
import 'package:flutter/material.dart';

import '../models/global.dart';

void showCorrectSnackBar(BuildContext context, bool correct) {
  String ret = (correct) ? "Correct: " : "Incorrect: ";
  ret += "\n${Global.getRandomMessage((correct) ? MessageType.passed : MessageType.failed)}";
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        ret,
      ),
    ),
  );
}
