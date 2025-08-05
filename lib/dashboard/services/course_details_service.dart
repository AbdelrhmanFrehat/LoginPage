import 'package:firebase_database/firebase_database.dart';
import 'package:teacher_portal/database/models/assignment_model.dart';
import 'package:teacher_portal/database/models/exam_model.dart';
import 'package:teacher_portal/database/models/submission_model.dart';

class CourseDetailsService {
  final _db = FirebaseDatabase.instance.ref();

  Future<List<Assignment>> getAssignments(String courseId) async {
    final snapshot = await _db.child('courses/$courseId/assignments').get();
    if (!snapshot.exists) return [];

    return (snapshot.value as Map).entries.map((entry) {
      final map = Map<String, dynamic>.from(entry.value);
      return Assignment.fromMap(map);
    }).toList();
  }

  Future<List<Exam>> getExams(String courseId) async {
    final snapshot = await _db.child('courses/$courseId/exams').get();
    if (!snapshot.exists) return [];

    return (snapshot.value as Map).entries.map((entry) {
      final map = Map<String, dynamic>.from(entry.value);
      return Exam.fromMap(map, id: entry.key, courseId: courseId);
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

  Future<List<Submission>> getAssignmentSubmissions({
    required String courseId,
    required String assignmentId,
  }) async {
    final ref = _db.child(
      'courses/$courseId/assignments/$assignmentId/submissions',
    );
    final snapshot = await ref.get();

    if (!snapshot.exists || snapshot.value == null || snapshot.value is! Map) {
      return [];
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    return data.entries.map((entry) {
      final submissionData = Map<String, dynamic>.from(entry.value);
      return Submission.fromMap(
        submissionData,
        id: entry.key,
        courseId: courseId,
        taskId: assignmentId,
        type: 'assignment',
      );
    }).toList();
  }

  Future<List<Submission>> getExamSubmissions({
    required String courseId,
    required String examId,
  }) async {
    final ref = _db.child('courses/$courseId/exams/$examId/submissions');
    final snapshot = await ref.get();

    if (!snapshot.exists || snapshot.value == null || snapshot.value is! Map) {
      return [];
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);

    return data.entries.map((entry) {
      final submissionData = Map<String, dynamic>.from(entry.value);
      return Submission.fromMap(
        submissionData,
        id: entry.key,
        courseId: courseId,
        taskId: examId,
        type: 'exam',
      );
    }).toList();
  }
}
