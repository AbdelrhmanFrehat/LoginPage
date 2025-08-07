import 'package:flutter/material.dart';
import 'package:teacher_portal/auth/viewmodels/login_viewmodel.dart';
import 'package:teacher_portal/dashboard/Models/Course-model.dart';
import 'package:teacher_portal/dashboard/services/course_api.dart';

class AddCourseViewModel extends ChangeNotifier {
  final AuthenticationViewModel authViewModel;
  final _courseApi = CourseApi();

  AddCourseViewModel({required this.authViewModel});

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final iconController = TextEditingController();

  double _progress = 0.0;
  double get progress => _progress;

  CourseStatus _selectedStatus = CourseStatus.inProgress;
  CourseStatus get selectedStatus => _selectedStatus;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setProgress(double value) {
    _progress = value;
    notifyListeners();
  }

  void setStatus(CourseStatus? status) {
    if (status != null) {
      _selectedStatus = status;
      notifyListeners();
    }
  }

  Future<String> submitCourse() async {
    if (!formKey.currentState!.validate()) {
      return ''; 
    }

    if (authViewModel.teacher == null || authViewModel.teacher!.id == null) {
      return "Error: Could not find teacher data.";
    }
    
    _isLoading = true;
    notifyListeners();

    final course = Course(
      teacherId: authViewModel.teacher!.id!,
      title: titleController.text.trim(),
      icon: iconController.text.trim(),
      progress: _progress,
      status: _selectedStatus,
    );
    
    try {
      final createdCourse = await _courseApi.create(course);
      return createdCourse.title; 
    } catch (e) {
      return "Error: $e"; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    iconController.dispose();
    super.dispose();
  }
}