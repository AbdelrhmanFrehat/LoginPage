// lib/dashboard/viewmodels/dashboard_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:teacher_portal/dashboard/Models/Course-model.dart';
import 'package:teacher_portal/dashboard/services/course_api.dart';

class DashboardViewModel extends ChangeNotifier {
  final CourseApi _courseApi = CourseApi();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  int _totalStudents = 0;
  int get totalStudents => _totalStudents;

  int _totalCourses = 0;
  int get totalCourses => _totalCourses;

  int _assignmentsGraded = 0;
  int get assignmentsGraded => _assignmentsGraded;

  int _examsHeld = 0;
  int get examsHeld => _examsHeld;

  Map<String, double> _assignmentSubmissionsData = {};
  Map<String, double> get assignmentSubmissionsData =>
      _assignmentSubmissionsData;

  Future<void> fetchDashboardData(String teacherId) async {
    _setLoading(true);

    try {
      final courses = await _courseApi.readAll(teacherId);
      _totalCourses = courses.length;

      await _calculateKeyMetrics(courses);

      await _calculateChartData(courses);
    } catch (e) {
      print("Error fetching dashboard data: $e");
    }

    _setLoading(false);
  }

  Future<void> _calculateKeyMetrics(List<Course> courses) async {
    int studentCount = 0;
    int gradedCount = 0;
    int examCount = 0;

    final Set<String> uniqueStudentIds = {};

    for (var course in courses) {
      course.enrolledStudents.keys.forEach(uniqueStudentIds.add);

      final assignments = await _courseApi.getAssignments(course.id!);
      for (var assignment in assignments) {
        if (assignment['submissions'] is Map) {
          final submissions = Map<String, dynamic>.from(
            assignment['submissions'],
          );
          submissions.forEach((key, value) {
            if (value is Map && value.containsKey('grade')) {
              gradedCount++;
            }
          });
        }
      }

      final exams = await _courseApi.getExams(course.id!);
      examCount += exams.length;
    }

    _totalStudents = uniqueStudentIds.length;
    _assignmentsGraded = gradedCount;
    _examsHeld = examCount;
  }

  Future<void> _calculateChartData(List<Course> courses) async {
    final Map<String, double> submissionsMap = {};

    for (var course in courses) {
      int submissionCount = 0;
      final assignments = await _courseApi.getAssignments(course.id!);
      for (var assignment in assignments) {
        if (assignment['submissions'] is Map) {
          submissionCount += (assignment['submissions'] as Map).length;
        }
      }
      final courseTitle = course.title.length > 10
          ? course.title.substring(0, 10)
          : course.title;
      submissionsMap[courseTitle] = submissionCount.toDouble();
    }

    _assignmentSubmissionsData = submissionsMap;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
