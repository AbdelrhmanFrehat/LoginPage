import 'package:firebase_database/firebase_database.dart';
import 'package:teacher_portal/database/models/assignment_model.dart';
import 'package:teacher_portal/database/models/exam_model.dart';

class CourseDetailsService {
  final _db = FirebaseDatabase.instance.ref();

  Future<List<Assignment>> getAssignments(String courseId) async {
    final snapshot = await _db.child('courses/$courseId/assignments').get();
    if (!snapshot.exists) return [];

    return (snapshot.value as Map).values.map((item) {
      return Assignment.fromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  Future<List<Exam>> getExams(String courseId) async {
    final snapshot = await _db.child('courses/$courseId/exams').get();
    if (!snapshot.exists) return [];

    return (snapshot.value as Map).values.map((item) {
      return Exam.fromMap(Map<String, dynamic>.from(item));
    }).toList();
  }

  Future<void> addAssignment(String courseId, Assignment assignment) async {
    final newRef = _db.child('courses/$courseId/assignments').push();
    await newRef.set(assignment.toMap());
  }

  Future<void> addExam(String courseId, Exam exam) async {
    final newRef = _db.child('courses/$courseId/exams').push();
    await newRef.set(exam.toMap());
  }
}
