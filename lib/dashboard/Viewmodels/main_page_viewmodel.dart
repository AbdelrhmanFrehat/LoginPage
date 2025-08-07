import 'package:flutter/material.dart';
import 'package:teacher_portal/dashboard/Models/Course-model.dart';
import 'package:teacher_portal/dashboard/services/course_api.dart';

class MainPageViewModel extends ChangeNotifier {
  final CourseApi _courseApi = CourseApi();
  
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Course> _courses = [];
  List<Course> get courses => _courses;

  List<Map<String, dynamic>> _upcomingAssignments = [];
  List<Map<String, dynamic>> get upcomingAssignments => _upcomingAssignments;
  
  List<Map<String, dynamic>> _allExams = [];
    List<Map<String, dynamic>> get allExams => _allExams; 

  List<Map<String, dynamic>> get upcomingExams => _allExams.where((e) => e['status'] == 'Upcoming').toList();
  List<Map<String, dynamic>> get activeExams => _allExams.where((e) => e['status'] == 'Active').toList();
  List<Map<String, dynamic>> get completedExams => _allExams.where((e) => e['status'] == 'Completed').toList();

  Future<void> fetchAllData(String teacherId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _courses = await _courseApi.readAll(teacherId);
      
      final List<Map<String, dynamic>> assignments = [];
      final List<Map<String, dynamic>> exams = [];

      for (final course in _courses) {
        final courseAssignments = await _courseApi.getAssignments(course.id!);
        assignments.addAll(courseAssignments.map((a) => {...a, 'courseName': course.title}));

        final courseExams = await _courseApi.getExams(course.id!);
        exams.addAll(courseExams.map((e) {
          final examDate = DateTime.tryParse(e['date'] ?? '');
          String status = 'Completed';
          if (examDate != null) {
            if (examDate.isAfter(DateTime.now())) {
              status = 'Upcoming';
            } else {
              status = 'Active'; 
            }
          }
          return {...e, 'courseName': course.title, 'status': status};
        }));
      }

      assignments.sort((a, b) {
        final dateA = DateTime.tryParse(a['dueDate'] ?? '');
        final dateB = DateTime.tryParse(b['dueDate'] ?? '');
        if (dateA == null || dateB == null) return 0;
        return dateA.compareTo(dateB);
      });

      _upcomingAssignments = assignments;
      _allExams = exams;

    } catch (e) {
      _errorMessage = e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }
}