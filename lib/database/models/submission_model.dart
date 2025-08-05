class Submission {
  final String id;
  final String studentId;
  final String courseId;
  final String taskId;
  final String type;
  // أعدنا content كحقل اختياري للواجبات النصية
  final String? content;
  // حقل الأجوبة للاختبارات
  final Map<String, dynamic>? answers;
  final DateTime submittedAt;
  final int? grade;
  final Map<String, dynamic>? awardedGrades;

  Submission({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.taskId,
    required this.type,
    this.content, // اختياري
    this.answers, // اختياري
    required this.submittedAt,
    this.grade,
    this.awardedGrades,
  });

  factory Submission.fromMap(
    Map<String, dynamic> map, {
    required String id,
    required String courseId,
    required String taskId,
    required String type,
  }) {
    return Submission(
      id: id,
      studentId: map['studentId'] ?? '',
      courseId: courseId,
      taskId: taskId,
      type: type,
      content: map['content'],
      answers: map['answers'] != null
          ? Map<String, dynamic>.from(map['answers'])
          : null,
      submittedAt:
          DateTime.tryParse(map['submittedAt'] ?? '') ?? DateTime.now(),
      grade: map['grade'],
      awardedGrades: map['awardedGrades'] != null
          ? Map<String, dynamic>.from(map['awardedGrades'])
          : null,
    );
  }
}
