import 'package:flutter/material.dart';
import 'package:teacher_portal/dashboard/services/exam_api.dart';
import 'package:teacher_portal/database/models/submission_model.dart';
import 'package:teacher_portal/firebase_database_service.dart';

class ExamSubmissionsViewModel extends ChangeNotifier {
  final String courseId;
  final String examId;

  final _examApi = ExamApi();
  final _db = FirebaseDatabaseService();

  ExamSubmissionsViewModel({required this.courseId, required this.examId}) {
    loadSubmissions();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Submission> _submissions = [];
  List<Submission> get submissions => _submissions;

  Map<String, String> _studentNames = {};
  Map<String, String> get studentNames => _studentNames;

  Future<void> loadSubmissions() async {
    _isLoading = true;
    notifyListeners();

    final data = await _examApi.getExamSubmissions(
      courseId: courseId,
      examId: examId,
    );

    final studentIds = data.map((s) => s.studentId).toSet();
    final nameMap = <String, String>{};
    for (final id in studentIds) {
      final snapshot = await _db.ref('users/$id').get();
      if (snapshot.exists && snapshot.value is Map) {
        final map = Map<String, dynamic>.from(snapshot.value as Map);
        nameMap[id] = map['fullName'] ?? 'Unknown';
      } else {
        nameMap[id] = 'Unknown';
      }
    }

    _submissions = data;
    _studentNames = nameMap;

    _isLoading = false;
    notifyListeners();
  }
}
