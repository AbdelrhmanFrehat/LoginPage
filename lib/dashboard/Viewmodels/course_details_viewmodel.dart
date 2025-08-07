import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:teacher_portal/dashboard/Models/Course-model.dart';
import 'package:teacher_portal/dashboard/services/course_api.dart';
import 'package:teacher_portal/database/models/assignment_model.dart';
import 'package:teacher_portal/firebase_database_service.dart';

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
      dueDate: dueDate.toIso8601String().split('T')[0],
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

  Future<void> sendNotificationToEnrolledStudents(
    String courseId,
    String messageText,
  ) async {
    final courseSnapshot = await _courseApi.ref('courses/$courseId').get();
    if (!courseSnapshot.exists) {
      print("❌ Course not found.");
      return;
    }

    final courseData = Map<String, dynamic>.from(courseSnapshot.value as Map);
    final enrolledStudentIds = (courseData['enrolledStudents'] as Map).keys
        .cast<String>()
        .toList();

    final tokens = <String>[];
    final studentTokenMap = <String, String>{};

    for (final studentId in enrolledStudentIds) {
      final studentSnapshot = await _courseApi.ref('users/$studentId').get();

      if (studentSnapshot.exists && studentSnapshot.value != null) {
        final raw = studentSnapshot.value;
        print("📦 بيانات الطالب $studentId: $raw");

        if (raw is Map && raw['tokens'] != null) {
          final tokenData = raw['tokens'];
          if (tokenData is List) {
            for (var token in tokenData) {
              tokens.add(token);
              studentTokenMap[token] = studentId;
            }
          } else if (tokenData is Map) {
            for (var value in tokenData.values.whereType<String>()) {
              tokens.add(value);
              studentTokenMap[value] = studentId;
            }
          } else {
            print("❌ Unexpected tokens format for $studentId: $tokenData");
          }
        } else {
          print("⚠️ No FCM tokens found for student $studentId");
        }
      }
    }

    if (tokens.isEmpty) {
      print("❌ No tokens found for enrolled students.");
      return;
    }

    int sent = 0;
    for (final token in tokens) {
      final studentId = studentTokenMap[token] ?? 'unknown';
      final success = await sendFcmNotification(
        token: 'd5uPqJ8hTNipmr9TWHgcNz:APA91bGeS68xQ9hm9QNm8pYl7HkjXQtnbcY_0ERvk3Yj-vaXj_vOGGPLk6-uK5gQLY9O4isobxEa_af1ezQtU2_oif35utRRbKTV9JcS-ysY23nxOHkR1SA',
        title: "📢 إشعار جديد من الأستاذ",
        body: messageText,
        studentId: studentId,
      );
      if (success) sent++;
    }

    print("✅ Notification sent to $sent students.");
  }

  Future<bool> sendFcmNotification({
    required String token,
    required String title,
    required String body,
    required String studentId,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("❌ No authenticated teacher.");
        return false;
      }

      final jsonString = await rootBundle.loadString(
        'assets/service_account.json',
      );
      final serviceAccount = ServiceAccountCredentials.fromJson(jsonString);
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final projectId = jsonMap['project_id']; // ← استخراج project ID

      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
      final authClient = await clientViaServiceAccount(serviceAccount, scopes);

      final url =
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

      final payload = {
        "message": {
          "token": token,
          "notification": {"title": title, "body": body},
          "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK"},
        },
      };

      final response = await authClient.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print("📤 Sent to $token - Status: ${response.statusCode}");
      print("📝 Response: ${response.body}");

      if (response.statusCode == 403 &&
          response.body.contains('SENDER_ID_MISMATCH')) {
        print("❌ SENDER_ID_MISMATCH for token: $token");
        return false;
      }

      if (response.statusCode == 404 &&
          response.body.contains('UNREGISTERED')) {
        print("🗑️ Removing invalid token from user $studentId: $token");
        final ref = _courseApi.ref('users/$studentId/tokens');
        final snapshot = await ref.get();
        if (snapshot.exists && snapshot.value is Map) {
          if (snapshot.exists && snapshot.value is Map) {
            final rawMap = snapshot.value as Map;
            final tokens = Map<String, dynamic>.from(rawMap);
            final updatedTokens = tokens
              ..removeWhere((_, value) => value == token);
            await ref.set(updatedTokens);
          }
        }
        return false;
      }

      final timestamp = DateTime.now().toIso8601String();
      final db = FirebaseDatabaseService();
      final notifRef = db.ref('teacherNotifications/${user.uid}').push();

      await notifRef.set({
        'title': title,
        'body': body,
        'timestamp': timestamp,
      });

      print("✅ Notification stored in teacherNotifications/${user.uid}");
      return true;
    } catch (e) {
      print("❌ Error sending FCM notification: $e");
      return false;
    }
  }
}
