class Lesson {
  final double number;
  final String section;
  final bool original;
  final List<String> goal;
  final String title;
  final String body;
  bool completed = false;

  Lesson(
    this.number,
    this.section,
    this.original,
    this.goal,
    this.title,
    this.body,
  );
}
