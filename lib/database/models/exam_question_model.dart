class ExamQuestion {
  final String questionText;
  final String type; // 'mcq', 'true_false', 'essay'
  final List<String>? options; // null for essay/true_false
  final dynamic correctAnswer;
  final int grade;

  ExamQuestion({
    required this.questionText,
    required this.type,
    this.options,
    this.correctAnswer,
    required this.grade,
  });

  factory ExamQuestion.fromMap(Map<String, dynamic> data) {
    return ExamQuestion(
      questionText: data['questionText'],
      type: data['type'],
      options: data['options'] != null
          ? List<String>.from(data['options'])
          : null,
      correctAnswer: data['correctAnswer'],
      grade: data['grade'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'type': type,
      if (options != null) 'options': options,
      'correctAnswer': correctAnswer,
      'grade': grade,
    };
  }
}
