import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../../l10n/app_localizations.dart';
import '../models/user.dart';
import '../services/user.service.dart';

class AuthenticationViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool isRegisterMode = false;
  String resultMsg = "";
  Users user = Users(
    username: '',
    password: '',
    fullname: '',
    email: '',
    phoneNumber: '',
  );

  void toggleMode() {
    isRegisterMode = !isRegisterMode;
    notifyListeners();
  }

  void clearUser() {
    user = Users(
      username: '',
      password: '',
      fullname: '',
      email: '',
      phoneNumber: '',
    );
    notifyListeners();
  }

  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

 Future<void> loginOrRegister(BuildContext context) async {
  final localizations = AppLocalizations.of(context)!;

  if (user.username.isEmpty || user.password.isEmpty) {
    resultMsg = localizations.emptyFieldsMsg;
    notifyListeners();
    return;
  }

  if (isRegisterMode) {
    final exists = await _userService.checkUsernameExists(user.username);
    if (exists) {
      resultMsg = localizations.usernameAlreadyExists;
      return;
    }

    user.password = hashPassword(user.password);
    await _userService.register(user);
    resultMsg = localizations.sucsessRegesterMsg;
    toggleMode();
  } else {
    final hashedPassword = hashPassword(user.password);
    final success = await _userService.login(user.username, hashedPassword);
    if (success) {
      await _storage.write(key: 'username', value: user.username);
      await _storage.write(key: 'password', value: hashedPassword);
      resultMsg = localizations.loginSucessMsg;
    } else {
      resultMsg = localizations.loginFailedMsg;
    }
  }
  notifyListeners();
}


 Future<bool> biometricLogin(BuildContext context) async {
  final localizations = AppLocalizations.of(context)!;
  try {
    bool isAuthenticated = await _localAuth.authenticate(
      localizedReason: localizations.biometricPrompt,
      options: const AuthenticationOptions(biometricOnly: true),
    );

    if (isAuthenticated) {
      String? storedUsername = await _storage.read(key: 'username');
      String? storedPassword = await _storage.read(key: 'password');

      if (storedUsername != null && storedPassword != null) {
        final success =
            await _userService.login(storedUsername, storedPassword);
        if (success) {
          user.username = storedUsername;
          user.password = storedPassword;
          return true;
        }
      }
    }
    return false;
  } catch (e) {
    print("Biometric error: $e");
    return false;
  }
}

}
