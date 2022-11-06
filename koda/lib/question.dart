class Question {
  final String section;
  final List<String> goal;
  final String? lesson;
  final double introDiff;
  final double interDiff;
  final String type;
  final String question;
  final Map<String, String>? options;
  final List<String>? correctQs;
  final String? answer;
  final Map<String, String>? explanations;
  bool seen = false;
  double? passrate;
  Question(
    this.section,
    this.goal,
    this.lesson,
    this.introDiff,
    this.interDiff,
    this.type,
    this.question,
    this.options,
    this.correctQs,
    this.answer,
    this.explanations,
  );
}
