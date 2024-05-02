class Question {
  final String text;
  final List<Answer> answers;

  Question(this.text, {required this.answers});
}

class Answer {
  final String text;
  final dynamic value;

  Answer(this.text, {required this.value});
}
