import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ مهم
import 'package:flutter_application_4/authentication/views/profile.dart';
import 'package:flutter_application_4/l10n/app_localizations.dart';
import 'package:flutter_application_4/l10n/i10n.dart';
import 'package:flutter_application_4/authentication/views/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'database/database.dart';
import 'authentication/view_models/authentication_view_model.dart'; // ✅ مهم

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance;
  runApp(
    MainApp(
      cruuntLang: Locale("ar"),
    ),
  );
}

class MainApp extends StatefulWidget {
  MainApp({super.key, required this.cruuntLang});
  var cruuntLang = Locale('ar');

  @override
  State<MainApp> createState() => _MainAppState(cruuntLang: cruuntLang);
}

class _MainAppState extends State<MainApp> {
  _MainAppState({required this.cruuntLang});
  var cruuntLang = Locale('ar');

  void changeCurrentLang() {
    setState(() {
      cruuntLang = (cruuntLang.languageCode == 'ar')
          ? Locale("en")
          : Locale("ar");
      print("Language changed to: $cruuntLang");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthenticationViewModel(),
      child: MaterialApp(
        theme: ThemeData.dark(),
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
          '/profile': (context) => const Profile()
        },
      ),
    );
  }
}
