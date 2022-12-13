import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../utilities/question.dart';
import 'completed_snackbar.dart';

///Builds a Widget specifically for Multiple Select questions
class MultipleSelectQuestion extends StatefulWidget {
  final Question question;
  final void Function() passed;
  final void Function() failed;

  const MultipleSelectQuestion({super.key, required this.question, required this.passed, required this.failed});

  @override
  State<MultipleSelectQuestion> createState() => _MultipleSelectQuestionState();
}

class _MultipleSelectQuestionState extends State<MultipleSelectQuestion> {
  final Set<String> _selectedOptions = {};
  bool _isCorrect = false;

  void _checkAnswer() {
    setState(() {
      _isCorrect = const IterableEquality().equals(_selectedOptions, widget.question.correctQs!.toSet());
      showCorrectSnackBar(context, _isCorrect);
      if (_isCorrect) {
        widget.passed();
      } else {
        widget.failed();
      }
    });
  }

  Widget _buildOption(String option) {
    return CheckboxListTile(
      title: Text(option),
      value: _selectedOptions.contains(option),
      onChanged: (value) {
        setState(() {
          if (value!) {
            _selectedOptions.add(option);
          } else {
            _selectedOptions.remove(option);
          }
        });
      },
    );
  }

  Widget _buildExplanation() {
    if (!_isCorrect) {
      return Container();
    }

    return Column(
      children: widget.question.correctQs!.map((correctAnswer) {
        String? explanation = widget.question.explanations![correctAnswer];

        return Text(
          '$correctAnswer: $explanation',
          style: const TextStyle(fontWeight: FontWeight.bold),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.question.question,
          style: Theme.of(context).textTheme.headline5,
        ),
        Column(
          children: widget.question.multipleOptions!.map(_buildOption).toList(),
        ),
        ElevatedButton(
          onPressed: _checkAnswer,
          child: const Text('Check Answer'),
        ),
        _buildExplanation(),
      ],
    );
  }
}
