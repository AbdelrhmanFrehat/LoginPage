import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:teacher_portal/database/models/teacher_model.dart';
import 'package:teacher_portal/firebase_database_service.dart';

class TeacherService {
  final DatabaseReference _internalRef = FirebaseDatabase.instance.ref(
    "teachers",
  );
  final DatabaseReference _externalRef = FirebaseDatabaseService().ref(
    "teachers",
  );

  Future<void> saveTeacherData(Teacher teacher) async {
    if (teacher.id == null) return;
    try {
      final teacherData = teacher.toMap();
      await Future.wait([
        _internalRef.child(teacher.id!).set(teacherData),
        _externalRef.child(teacher.id!).set(teacherData),
      ]);
      print("✅ Teacher data saved to BOTH databases.");
    } catch (e) {
      print("❌ Error saving teacher data to one or both databases: $e");
    }
  }

  Future<Teacher?> getTeacherById(String uid) async {
    Teacher? externalTeacher;
    Teacher? internalTeacher;

    // Check EXTERNAL DB
    try {
      print("ℹ️ Searching for teacher in EXTERNAL database...");
      final externalSnapshot = await _externalRef.child(uid).get();
      if (externalSnapshot.exists) {
        print("✅ Found teacher in EXTERNAL database.");
        final data = Map<String, dynamic>.from(externalSnapshot.value as Map);
        print("📦 Raw Teacher JSON from EXTERNAL DB:\n${jsonEncode(data)}");

        externalTeacher = Teacher.fromMap(data, uid);
      }
    } catch (e) {
      print("❌ Error fetching from EXTERNAL database: $e");
    }

    // Check INTERNAL DB
    try {
      print("ℹ️ Checking INTERNAL database...");
      final internalSnapshot = await _internalRef.child(uid).get();
      if (internalSnapshot.exists) {
        final data = Map<String, dynamic>.from(internalSnapshot.value as Map);
        print("📦 Raw Teacher JSON from INTERNAL DB:\n${jsonEncode(data)}");

        internalTeacher = Teacher.fromMap(data, uid);
      }
    } catch (e) {
      print("❌ Error fetching from INTERNAL database: $e");
    }

    // Prefer the one that has fcmTokens
    if (externalTeacher != null && externalTeacher.fcmTokens.isNotEmpty) {
      print("✅ Returning teacher from EXTERNAL (has FCM token).");
      return externalTeacher;
    }

    if (internalTeacher != null && internalTeacher.fcmTokens.isNotEmpty) {
      print("✅ Returning teacher from INTERNAL (has FCM token).");
      return internalTeacher;
    }

    // If both exist, prefer external
    if (externalTeacher != null) {
      print("⚠️ Returning teacher from EXTERNAL (no FCM token).");
      return externalTeacher;
    }

    if (internalTeacher != null) {
      print("⚠️ Returning teacher from INTERNAL (no FCM token).");
      return internalTeacher;
    }

    print("❌ Teacher not found in any database.");
    return null;
  }

  Future<void> updateTeacherData(Teacher teacher) async {
    if (teacher.id == null) return;
    try {
      final updateData = {'fullName': teacher.fullName, 'phone': teacher.phone};
      await Future.wait([
        _internalRef.child(teacher.id!).update(updateData),
        _externalRef.child(teacher.id!).update(updateData),
      ]);
      print("✅ Teacher data updated in BOTH databases.");
    } catch (e) {
      print("❌ Error updating teacher data in one or both databases: $e");
    }
  }

  Future<void> addFcmToken(String teacherId, String token) async {
    final internalTokenRef = _internalRef.child(teacherId).child('fcmTokens');
    final externalTokenRef = _externalRef.child(teacherId).child('fcmTokens');

    // ✅ هذه دالة غير متزامنة (بدون async)
    Transaction transactionHandler(Object? currentData) {
      List<dynamic> tokens = [];

      if (currentData != null) {
        tokens = List<dynamic>.from(currentData as List);
      }

      if (!tokens.contains(token)) {
        tokens.add(token);
      }

      return Transaction.success(tokens);
    }

    try {
      print("ℹ️ Attempting to add FCM token to BOTH databases...");

      // ✅ مرر الدالة مباشرة بدون انتظار داخلي
      await Future.wait([
        internalTokenRef.runTransaction(transactionHandler),
        externalTokenRef.runTransaction(transactionHandler),
      ]);

      print("✅ FCM token updated in BOTH databases.");
    } catch (e) {
      print("❌ Error updating FCM token in one or both databases: $e");
    }
  }
}
