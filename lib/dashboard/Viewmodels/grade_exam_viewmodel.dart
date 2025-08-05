import 'package:flutter/material.dart';
import 'package:teacher_portal/dashboard/services/exam_api.dart';
import 'package:teacher_portal/database/models/submission_model.dart';

class GradeExamViewModel extends ChangeNotifier {
  final Submission submission;
  final _examApi = ExamApi();

  final gradeController = TextEditingController();

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  GradeExamViewModel({required this.submission}) {
    gradeController.text = submission.grade?.toString() ?? '';
  }

  Future<bool> saveGrade() async {
    final grade = int.tryParse(gradeController.text);
    if (grade == null) {
      return false;
    }

    _isSaving = true;
    notifyListeners();

    try {
      await _examApi.updateGrade(
        courseId: submission.courseId,
        examId: submission.taskId,
        submissionId: submission.id,
        grade: grade,
      );
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("Error saving grade: $e");
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    gradeController.dispose();
    super.dispose();
  }
}
