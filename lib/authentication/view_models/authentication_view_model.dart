import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email,
          password: user.password,
        );

        user.password = hashPassword(user.password);
        await _userService.register(user);

        await _userService.saveCredentials(user.username, user.password);

        resultMsg = localizations.sucsessRegesterMsg;
        toggleMode();
      } on FirebaseAuthException catch (e) {
        resultMsg = e.message ?? localizations.loginFailedMsg;
      }
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user.email,
          password: user.password,
        );

        final hashedPassword = hashPassword(user.password);
        final success = await _userService.login(user.username, hashedPassword);
        if (success) {
          await _userService.saveCredentials(user.username, hashedPassword);
          resultMsg = localizations.loginSucessMsg;
        } else {
          resultMsg = localizations.loginFailedMsg;
        }
      } on FirebaseAuthException catch (e) {
        resultMsg = e.message ?? localizations.loginFailedMsg;
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
        final credentials = await _userService.getCredentials(
          user.username,
          user.password,
        );

        if (credentials['username'] != null &&
            credentials['password'] != null) {
          final success = await _userService.login(
            credentials['username']!,
            credentials['password']!,
          );
          if (success) {
            user.username = credentials['username']!;
            user.password = credentials['password']!;
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
