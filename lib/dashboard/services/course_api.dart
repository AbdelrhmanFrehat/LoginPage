import 'package:firebase_database/firebase_database.dart';
import '../../firebase_database_service.dart';
import '../Models/Course-model.dart';
import '../Repositories/course_repository.dart';

class CourseApi extends CourseRepository {
  final DatabaseReference _coursesRef = FirebaseDatabaseService().ref(
    'courses',
  );

  @override
  Future<Course> create(Course course) async {
    final newRef = _coursesRef.push();
    await newRef.set(course.toMap());

    return course.copyWith(id: newRef.key);
  }

  @override
  Future<List<Course>> readAll(String teacherId) async {
    final List<Course> courses = [];
    try {
      final snapshot = await _coursesRef.get();
      if (snapshot.exists && snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        data.forEach((courseId, courseData) {
          final courseMap = Map<String, dynamic>.from(courseData);
          if (courseMap['teacherId'] == teacherId) {
            courses.add(Course.fromMap(courseMap, courseId));
          }
        });
      }
    } catch (e) {
      print('❌ Error reading courses for teacher $teacherId: $e');
    }
    return courses;
  }

  @override
  Future<int> update(Course course) async {
    if (course.id == null || course.id!.isEmpty) {
      print('❌ Course ID is missing. Cannot update.');
      return 0;
    }
    try {
      await _coursesRef.child(course.id!).update(course.toMap());
      return 1;
    } catch (e) {
      print('❌ Error updating course ${course.id}: $e');
      return 0;
    }
  }

  @override
  Future<int> delete(String courseId) async {
    try {
      await _coursesRef.child(courseId).remove();
      return 1;
    } catch (e) {
      print('❌ Error deleting course $courseId: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getAssignments(String courseId) async {
    final ref = FirebaseDatabaseService().ref('courses/$courseId/assignments');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.entries
          .map((e) => {'id': e.key, ...Map<String, dynamic>.from(e.value)})
          .toList();
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getExams(String courseId) async {
    final ref = FirebaseDatabaseService().ref('courses/$courseId/exams');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return data.entries
          .map((e) => {'id': e.key, ...Map<String, dynamic>.from(e.value)})
          .toList();
    }
    return [];
  }

  Future readByTeacherId(String teacherId) async {}
}
