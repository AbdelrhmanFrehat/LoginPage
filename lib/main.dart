import 'package:flutter/material.dart';
import 'package:flutter_application_4/l10n/app_localizations.dart';
import 'package:flutter_application_4/l10n/i10n.dart';
import 'package:flutter_application_4/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'database/database.dart';
import 'l10n/i10n.dart';

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
    var temp;
    setState(() {
      cruuntLang == Locale('ar')
          ? cruuntLang = Locale("en")
          : cruuntLang = Locale("ar");
      print(cruuntLang);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
      debugShowCheckedModeBanner:false ,
        supportedLocales: L10n.all,
        locale: cruuntLang,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: LoginPage(
          change: changeCurrentLang,
          cruuntLang: cruuntLang,
        ));
  }
}
