
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFFF5F5FA), 
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white, 
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.black, 
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF121212), 
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850], 
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.white, 
    ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.blue, 
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    ),
  );
}