import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teachar_app/authentication/views/profile.dart';
import 'package:teachar_app/l10n/app_localizations.dart';
import 'package:teachar_app/l10n/i10n.dart';
import 'package:teachar_app/authentication/views/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:teachar_app/main/views/main_view.dart';
import 'package:teachar_app/theme_provider.dart';
import 'database/database.dart';
import 'authentication/view_models/authentication_view_model.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  await Firebase.initializeApp();
  await DatabaseHelper.instance.database;

  runApp(MainApp(cruuntLang: const Locale("ar")));
}

final lightTheme = ThemeData.light();
final darkTheme = ThemeData.dark();

class MainApp extends StatefulWidget {
  MainApp({super.key, required this.cruuntLang});

  var cruuntLang = Locale('ar');

  @override
  State<MainApp> createState() => _MainAppState(cruuntLang: cruuntLang);
}

class _MainAppState extends State<MainApp> {
  _MainAppState({required this.cruuntLang});
  var cruuntLang = Locale('ar');
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  bool isDarkMode = false;
  @override
  initState() {
    super.initState();
    voidLoadDarkMode();
  }

  void changeCurrentLang() {
    setState(() {
      cruuntLang = (cruuntLang.languageCode == 'ar')
          ? Locale("en")
          : Locale("ar");
      print("Language changed to: $cruuntLang");
    });
  }

  voidLoadDarkMode() async {
    final storedValue = await _storage.read(key: 'isDarkMode');

    setState(() {
      isDarkMode = storedValue == 'true';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            theme: themeProvider.isDarkMode
                ? ThemeData.dark()
                : ThemeData.light(),
            debugShowCheckedModeBanner: false,
            supportedLocales: L10n.all,
            locale: cruuntLang,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routes: {
              '/': (context) =>
                  LoginPage(change: changeCurrentLang, cruuntLang: cruuntLang),
              '/profile': (context) => const Profile(),
              '/main': (context) => MainView(),
            },
          );
        },
      ),
    );
  }
}
