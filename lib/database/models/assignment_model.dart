class Assignment {
  final String title;
  final String dueDate;
  final int submissions;

  Assignment({
    required this.title,
    required this.dueDate,
    required this.submissions,
  });

  factory Assignment.fromMap(Map<String, dynamic> data) {
    return Assignment(
      title: data['title'],
      dueDate: data['dueDate'],
      submissions: data['submissions'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'dueDate': dueDate, 'submissions': submissions};
  }
}
