import 'package:flutter/material.dart';
import 'package:teacher_portal/database/models/submission_model.dart';
import 'package:teacher_portal/firebase_database_service.dart';

class AssignmentDetailsViewModel extends ChangeNotifier {
  final _db = FirebaseDatabaseService();

  final String courseId;
  final String assignmentId;
  final List<Map<String, dynamic>> enrolledStudents;

  AssignmentDetailsViewModel({
    required this.courseId,
    required this.assignmentId,
    required this.enrolledStudents,
  }) {
    _loadData();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Submission> _submissions = [];
  List<Submission> get submissions => _submissions;

  Set<String> _notSubmittedIds = {};
  Set<String> get notSubmittedIds => _notSubmittedIds;

  final Map<String, String> _studentNames = {};
  Map<String, String> get studentNames => _studentNames;

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    await _loadStudentNames();
    await _loadSubmissions();
    _calculateNotSubmitted();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadStudentNames() async {
    for (var student in enrolledStudents) {
      final id = student['id'];
      final name = student['name'] ?? 'Unknown';
      _studentNames[id] = name;
    }
  }

  Future<void> _loadSubmissions() async {
    final snapshot = await _db
        .ref('courses/$courseId/assignments/$assignmentId/submissions')
        .get();

    if (snapshot.exists && snapshot.value is Map) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      _submissions = data.entries.map((entry) {
        final submissionData = Map<String, dynamic>.from(entry.value);
        return Submission.fromMap(
          submissionData,
          id: entry.key,
          courseId: courseId,
          taskId: assignmentId,
          type: 'assignment',
        );
      }).toList();
    } else {
      _submissions = [];
    }
  }

  void _calculateNotSubmitted() {
    final submittedIds = _submissions.map((s) => s.studentId).toSet();
    final allStudentIds = enrolledStudents
        .map((s) => s['id'] as String)
        .toSet();
    _notSubmittedIds = allStudentIds.difference(submittedIds);
  }

  Future<void> updateGrade(String submissionId, int grade) async {
    try {
      await _db
          .ref(
            'courses/$courseId/assignments/$assignmentId/submissions/$submissionId',
          )
          .update({'grade': grade});
      await _loadSubmissions();
      notifyListeners();
    } catch (e) {
      print("Failed to update grade: $e");
    }
  }

  String formatDateTime(DateTime dt) {
    final date =
        "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
    final time =
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    return "$date $time";
  }
}
