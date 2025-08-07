import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar'); 
  final _storage = const FlutterSecureStorage();

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final languageCode = await _storage.read(key: 'language_code');
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;
    
    _locale = newLocale;
    await _storage.write(key: 'language_code', value: newLocale.languageCode);
    notifyListeners();
  }

  void toggleLocale() {
    if (_locale.languageCode == 'en') {
      setLocale(const Locale('ar'));
    } else {
      setLocale(const Locale('en'));
    }
  }
}