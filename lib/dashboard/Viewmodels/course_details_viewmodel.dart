import 'package:flutter/material.dart';
import 'package:teacher_portal/dashboard/Models/Course-model.dart';
import 'package:teacher_portal/dashboard/services/course_api.dart';
import 'package:teacher_portal/database/models/assignment_model.dart';

class CourseDetailsViewModel extends ChangeNotifier {
  final CourseApi _courseApi = CourseApi();
  final Course course;

  CourseDetailsViewModel({required this.course}) {
    loadAllData();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _assignments = [];
  List<Map<String, dynamic>> get assignments => _assignments;

  List<Map<String, dynamic>> _exams = [];
  List<Map<String, dynamic>> get exams => _exams;

  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> get students => _students;

  Future<void> loadAllData() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([loadEnrolledStudents(), loadAssignmentsAndExams()]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadEnrolledStudents() async {
    final enrolled = course.enrolledStudents;
    if (enrolled.isEmpty) {
      _students = [];
      return;
    }

    final studentsList = <Map<String, dynamic>>[];
    for (final studentId in enrolled.keys) {
      final snapshot = await _courseApi.ref('users/$studentId').get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        studentsList.add({
          'id': studentId,
          'name': data['fullName'] ?? 'Unknown',
          'email': data['email'] ?? 'N/A',
        });
      }
    }
    _students = studentsList;
  }

  Future<void> loadAssignmentsAndExams() async {
    _assignments = await _courseApi.getAssignments(course.id!);
    _exams = await _courseApi.getExams(course.id!);
  }

  Future<void> addAssignment(String title, DateTime dueDate) async {
    final newAssignment = Assignment(
      title: title,
      dueDate: dueDate.toIso8601String().split('T')[0], // format as YYYY-MM-DD
      submissions: 0,
    );
    final newRef = _courseApi.ref('courses/${course.id}/assignments').push();
    await newRef.set(newAssignment.toMap());
    await loadAssignmentsAndExams();
    notifyListeners();
  }

  Future<void> deleteAssignment(String assignmentId) async {
    await _courseApi
        .ref('courses/${course.id}/assignments/$assignmentId')
        .remove();
    await loadAssignmentsAndExams();
    notifyListeners();
  }

  Future<void> deleteExam(String examId) async {
    await _courseApi.ref('courses/${course.id}/exams/$examId').remove();
    await loadAssignmentsAndExams();
    notifyListeners();
  }
}
