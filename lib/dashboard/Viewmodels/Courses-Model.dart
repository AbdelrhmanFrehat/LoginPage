import 'package:flutter/material.dart';
import 'package:teacher_portal/auth/viewmodels/login_viewmodel.dart';
import '../Models/Course-model.dart';
import '../services/course_api.dart';
import 'package:provider/provider.dart';

Future<List<Course>> fetchCoursesFromDatabase(BuildContext context) async {
  final courseApi = CourseApi();
  final teacherId = context
      .read<AuthenticationViewModel>()
      .teacher
      .id
      .toString();

  try {
    final List<Course> courses = await courseApi.readAll(teacherId);
    print("✅ Fetched ${courses.length} courses for teacherId: $teacherId");
    return courses;
  } catch (e) {
    print("❌ Error fetching courses: $e");
    return [];
  }
}
