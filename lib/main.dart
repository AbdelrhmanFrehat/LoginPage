// main.dart (النسخة الكاملة والمعدلة)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_portal/auth/viewmodels/login_viewmodel.dart';
import 'package:teacher_portal/dashboard/Viewmodels/dashboard_viewmodel.dart';
import 'package:teacher_portal/dashboard/Viewmodels/main_page_viewmodel.dart';
import 'package:teacher_portal/dashboard/services/notification_service.dart';
import 'package:teacher_portal/database/db_helper.dart';
import 'package:teacher_portal/firebase_database_service.dart';
import 'package:teacher_portal/generated/app_localizations.dart'
    show AppLocalizations;
import 'package:teacher_portal/l10n/LocaleProvider.dart';
import 'package:teacher_portal/theme_provider.dart';
import 'auth/views/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    DBHelper.instance;
    await FirebaseDatabaseService().initialize(
      url: 'https://users-99855-default-rtdb.firebaseio.com/',
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _requestNotificationPermission();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthenticationViewModel()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => DashboardViewModel()),
          ChangeNotifierProvider(create: (_) => MainPageViewModel()),
          ChangeNotifierProvider(create: (_) => NotificationService()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print("Firebase initialization failed: $e");
    runApp(const ErrorApp());
  }
}

Future<void> _requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(AppLocalizations.of(context)!.errorFirebaseInit),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final localeProvider = context.watch<LocaleProvider>();

        return MaterialApp(
          theme: ThemeProvider.lightTheme,
          locale: localeProvider.locale,
          darkTheme: ThemeProvider.darkTheme,

          themeMode: themeProvider.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

          home: const FirebaseMessagingHandler(child: LoginView()),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('ar')],
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class FirebaseMessagingHandler extends StatefulWidget {
  final Widget child;
  const FirebaseMessagingHandler({super.key, required this.child});

  @override
  State<FirebaseMessagingHandler> createState() =>
      _FirebaseMessagingHandlerState();
}

class _FirebaseMessagingHandlerState extends State<FirebaseMessagingHandler> {
  @override
  void initState() {
    super.initState();
    final notificationService = context.read<NotificationService>();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      notificationService.addNotification(message);

      if (message.notification != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message.notification!.title ?? 'New Notification'),
          ),
        );
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        print(
          'App opened from terminated state by a notification: ${message.data}',
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
        'App opened from background state by a notification: ${message.data}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
