import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:teacher_portal/firebase_database_service.dart';
import 'package:teacher_portal/auth/services/teacher_service.dart';

class TeacherNotificationService {
  final DatabaseReference _notificationsRef = FirebaseDatabaseService().ref('teacherNotifications');

  Future<void> saveNotification({
    required String title,
    required String body,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("❌ لا يوجد مستخدم حالياً");
      return;
    }

    final teacherService = TeacherService();
    final teacher = await teacherService.getTeacherById(user.uid);
    if (teacher == null) {
      print("❌ لم يتم العثور على بيانات المعلم");
      return;
    }

    final notifRef = _notificationsRef.child(user.uid).push();

    final notificationData = {
      'id': notifRef.key,
      'title': title,
      'body': body,
      'teacherName': teacher.fullName,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await notifRef.set(notificationData);

    print("✅ تم حفظ الإشعار في قاعدة البيانات");
  }

  Future<List<Map<String, dynamic>>> fetchNotifications() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final snapshot = await _notificationsRef.child(user.uid).get();
    if (!snapshot.exists || snapshot.value == null) return [];

    final rawData = Map<String, dynamic>.from(snapshot.value as Map);
    final notifications = rawData.entries.map((entry) {
      final data = Map<String, dynamic>.from(entry.value);
      return {
        'id': data['id'],
        'title': data['title'],
        'body': data['body'],
        'teacherName': data['teacherName'],
        'timestamp': data['timestamp'],
      };
    }).toList();

    notifications.sort((a, b) =>
        DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp'])));

    return notifications;
  }
}