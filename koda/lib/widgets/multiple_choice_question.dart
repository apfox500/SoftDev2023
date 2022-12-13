import 'package:flutter/material.dart';

import '../utilities/question.dart';
import 'completed_snackbar.dart';

///Builds a Widget specifically for Multiple Choice questions
class MultipleChoiceQuestion extends StatefulWidget {
  final Question question;
  final void Function() passed;
  final void Function() failed;

  const MultipleChoiceQuestion({super.key, required this.question, required this.passed, required this.failed});

  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  bool _isCorrect = false;
  String? answer;

  void _checkAnswer(String answer) {
    setState(() {
      this.answer = answer;
      _isCorrect = widget.question.correctQs!.contains(answer);
      showCorrectSnackBar(context, _isCorrect);
      if (!_isCorrect) {
        widget.failed();
      } else {
        widget.passed();
      }
    });
  }

  Widget _buildQuestion() {
    return Text(
      widget.question.question,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget _buildOptions() {
    return Column(
      children: widget.question.multipleOptions!.map((option) {
        return RadioListTile<String>(
          title: Text(
            option,
          ),
          value: option,
          groupValue: answer,
          onChanged: (value) => _checkAnswer(value!),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildQuestion(),
        _buildOptions(),
      ],
    );
  }
}
