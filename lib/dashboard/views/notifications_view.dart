import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_portal/dashboard/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  void _sendTestNotification(BuildContext context) {
    final fakeMessage = RemoteMessage(
      notification: RemoteNotification(
        title: '🔔 Test Notification',
        body:
            'This is a sample notification sent at ${TimeOfDay.now().format(context)}',
      ),
    );

    context.read<NotificationService>().addNotification(fakeMessage);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Test notification added!')));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationService>(
      builder: (context, notificationService, child) {
        final notifications = notificationService.notifications;

        // load stored notifications
        if (notifications.isEmpty) {
          notificationService.fetchStoredNotifications();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Notifications'),
            actions: [
              if (notifications.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear_all),
                  onPressed: () {
                    notificationService.clearNotifications();
                    // optionally clear from Firebase too
                  },
                  tooltip: 'Clear All',
                ),
            ],
          ),
          body: notifications.isEmpty
              ? _buildEmptyState()
              : _buildNotificationsList(notifications),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final service = context.read<NotificationService>();
              await service.sendAndStoreNotificationToStudents(
                title: 'Test Notification',
                body:
                    'This is a test notification sent at ${TimeOfDay.now().format(context)}',
                courseId: '',
              );
              await service.fetchStoredNotifications();
            },
            tooltip: 'Send Test Notification',
            child: const Icon(Icons.send),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Press the send button to add a test notification.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<AppNotification> notifications) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.notifications, color: Colors.white),
            ),
            title: Text(
              notification.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(notification.body),
            trailing: Text(
              _formatTimeAgo(notification.receivedAt),
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        );
      },
    );
  }

  String _formatTimeAgo(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
