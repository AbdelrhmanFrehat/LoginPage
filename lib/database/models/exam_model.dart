class Exam {
  final String title;
  final String date;
  final int submitted;

  Exam({required this.title, required this.date, required this.submitted});

  factory Exam.fromMap(Map<String, dynamic> data) {
    return Exam(
      title: data['title'],
      date: data['date'],
      submitted: data['submitted'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'date': date, 'submitted': submitted};
  }
}
