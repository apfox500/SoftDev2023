import 'package:flutter/material.dart';

import '../utilities/question.dart';
import 'completed_snackbar.dart';

///Builds a Widget specifically for Short Answer Questions
class ShortAnswerQuestion extends StatelessWidget {
  const ShortAnswerQuestion({required this.question, super.key, required this.passed, required this.failed});
  final Question question;
  final void Function() passed;
  final void Function() failed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          question.question,
          style: Theme.of(context).textTheme.headline5,
        ),
        TextField(
          onSubmitted: (value) {
            if (value == question.shortAnswer) {
              showCorrectSnackBar(context, true);
              passed();
            } else {
              showCorrectSnackBar(context, false);
              failed();
            }
          },
        ),
      ],
    );
  }
}
