import 'package:firebase_database/firebase_database.dart';
import 'package:teacher_portal/database/models/submission_model.dart';
import '../../firebase_database_service.dart';

class ExamApi {
  final DatabaseReference _db = FirebaseDatabaseService().ref('courses');

  Future<List<Submission>> getExamSubmissions({
    required String courseId,
    required String examId,
  }) async {
    final ref = _db.child('$courseId/exams/$examId/submissions');
    final snapshot = await ref.get();

    if (!snapshot.exists || snapshot.value == null || snapshot.value is! Map) {
      return [];
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    return data.entries.map((entry) {
      final submissionData = Map<String, dynamic>.from(entry.value);
      return Submission.fromMap(
        submissionData,
        id: entry.key,
        courseId: courseId,
        taskId: examId,
        type: 'exam',
      );
    }).toList();
  }

  Future<void> updateGrade({
    required String courseId,
    required String examId,
    required String submissionId,
    required int grade,
    Map<String, dynamic>? awardedGrades,
  }) async {
    final ref = _db.child('$courseId/exams/$examId/submissions/$submissionId');
    final Map<String, dynamic> updates = {'grade': grade};
    if (awardedGrades != null) {
      updates['awardedGrades'] = awardedGrades;
    }
    await ref.update(updates);
  }
}
