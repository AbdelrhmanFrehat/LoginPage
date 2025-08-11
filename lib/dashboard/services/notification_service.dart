import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:teacher_portal/firebase_database_service.dart';

class AppNotification {
  final String title;
  final String body;
  final DateTime receivedAt;

  AppNotification({
    required this.title,
    required this.body,
    required this.receivedAt,
  });
}

class NotificationService extends ChangeNotifier {
  final List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initializeLocalNotifications();
  }

  void _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          addLocalNotification(response.payload!);
        }
      },
    );
  }

  void addNotification(RemoteMessage message) {
    final title = message.notification?.title ?? 'No Title';
    final body = message.notification?.body ?? 'No Body';

    _notifications.insert(
      0,
      AppNotification(title: title, body: body, receivedAt: DateTime.now()),
    );
    notifyListeners();

    _showLocalNotification(title, body);
  }

  void addLocalNotification(String body) {
    _notifications.insert(
      0,
      AppNotification(title: 'تنبيه داخلي', body: body, receivedAt: DateTime.now()),
    );
    notifyListeners();
  }
Future<void> fetchStoredNotifications() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final db = FirebaseDatabaseService();
  final snapshot = await db.ref('teacherNotifications/${user.uid}').get();

  if (snapshot.exists && snapshot.value != null) {
    final data = Map<String, dynamic>.from(snapshot.value as Map);

    _notifications.clear();
    data.forEach((key, value) {
      final notif = AppNotification(
        title: value['title'] ?? '',
        body: value['body'] ?? '',
        receivedAt: DateTime.tryParse(value['timestamp'] ?? '') ??
            DateTime.now(),
      );
      _notifications.add(notif);
    });

    // sort by date desc
    _notifications.sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
    notifyListeners();
  }
}

  void _showLocalNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'main_channel',
      'Main Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(0, title, body, details, payload: body);
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }



  int _lastCount = 0;

  
  Future<void> sendAndStoreNotificationToStudents({
    required String courseId,
    required String title,
    required String body,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final db = FirebaseDatabaseService();
      final courseSnapshot = await db.ref('courses/$courseId').get();

      if (!courseSnapshot.exists || courseSnapshot.value == null) return;

      final courseData = Map<String, dynamic>.from(courseSnapshot.value as Map);
      final enrolled = courseData['enrolled'] ?? [];
      if (enrolled is! List) return;

      final tokens = <String>[];
      for (var studentId in enrolled) {
        final studentSnapshot = await db.ref('students/$studentId').get();
        if (studentSnapshot.exists && studentSnapshot.value != null) {
          final data = Map<String, dynamic>.from(studentSnapshot.value as Map);
          final fcmTokens = data['fcmTokens'];
          if (fcmTokens is List) tokens.addAll(List<String>.from(fcmTokens));
        }
      }

      final jsonString = await rootBundle.loadString('assets/teacher-app-b1621-firebase-adminsdk.json');
      final serviceAccount = ServiceAccountCredentials.fromJson(jsonString);
      final authClient = await clientViaServiceAccount(serviceAccount, [
        'https://www.googleapis.com/auth/firebase.messaging',
      ]);

      for (var token in tokens) {
        final payload = {
          "message": {
            "token": token,
            "notification": {"title": title, "body": body},
            "data": {"courseId": courseId, "click_action": "FLUTTER_NOTIFICATION_CLICK"},
          },
        };

        final response = await authClient.post(
          Uri.parse('https://fcm.googleapis.com/v1/projects/teacher-app-b1621/messages:send'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(payload),
        );

        print("\ud83d\udce4 Sent to $token → Status: ${response.statusCode}");
      }

      await saveNotificationForTeacher(user.uid, title, body);
    } catch (e) {
      print("❌ Failed to send/store notification: $e");
    }
  }

  Future<void> saveNotificationForTeacher(String teacherId, String title, String body) async {
    final ref = FirebaseDatabaseService().ref('teacherNotifications/$teacherId').push();
    await ref.set({
      'title': title,
      'body': body,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> fetchTeacherNotifications(String teacherId) async {
    final ref = FirebaseDatabaseService().ref('teacherNotifications/$teacherId');
    final snapshot = await ref.get();
    if (!snapshot.exists || snapshot.value == null) return [];

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return data.entries.map((e) {
      final notif = Map<String, dynamic>.from(e.value);
      return {'id': e.key, ...notif};
    }).toList()
      ..sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
  }
}
