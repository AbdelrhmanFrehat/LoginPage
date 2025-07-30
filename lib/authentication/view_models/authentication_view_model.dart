import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teachar_app/database/database.dart';

import '../../l10n/app_localizations.dart';
import '../models/user.dart';
import '../services/user.service.dart';
import 'package:id_gen/id_gen_helpers.dart';

class AuthenticationViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool isRegisterMode = false;
  String resultMsg = "";
  Users user = Users(
    id: 0,
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
      id: 0,
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

        user.id = genTimeId;
        final hashedPassword = hashPassword(user.password);
        user.password = hashedPassword;

        await _userService.register(user);
        await _userService.saveCredentials(
          user.username,
          hashedPassword,
          user.id!,
        );

        resultMsg = localizations.sucsessRegesterMsg;
        toggleMode();
      } on FirebaseAuthException catch (e) {
        resultMsg = e.message ?? localizations.loginFailedMsg;
      }
    } else {
     try {
  Users? matchedUser;

  // 1. نحاول محليًا أولاً
  matchedUser = await _userService.getUserByUsername(user.username);

  if (matchedUser != null) {
    final hashedInputPassword = hashPassword(user.password);
    final localLoginSuccess = await _userService.login(user.username, hashedInputPassword);

    if (localLoginSuccess) {
      await _userService.saveCredentials(user.username, hashedInputPassword, matchedUser.id!);
      user = matchedUser;
      resultMsg = localizations.loginSucessMsg;
      notifyListeners();
      return;
    } else {
      resultMsg = localizations.loginFailedMsg;
      notifyListeners();
      return;
    }
  }

  final connected = await checkInternetConnection(); // سنشرحها بعد قليل
  if (!connected) {
    resultMsg = "🚫 لا يوجد اتصال بالإنترنت ولا بيانات محلية.";
    notifyListeners();
    return;
  }

  final ref = FirebaseDatabase.instance.ref().child('users');
  final snapshot = await ref.get();

  if (!snapshot.exists) {
    resultMsg = "❌ لا توجد قاعدة بيانات مستخدمين على Firebase.";
    notifyListeners();
    return;
  }

  final allUsers = Map<String, dynamic>.from(snapshot.value as Map);
  for (var entry in allUsers.entries) {
    final data = Map<String, dynamic>.from(entry.value);
    if (data['username'] == user.username) {
      matchedUser = Users(
        id: int.parse(entry.key),
        username: data['username'],
        email: data['email'],
        fullname: data['fullname'],
        phoneNumber: data['phoneNumber'],
        password: hashPassword(user.password),
      );
      break;
    }
  }

  if (matchedUser == null) {
    resultMsg = "❌ المستخدم غير موجود على Firebase.";
    notifyListeners();
    return;
  }

  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: matchedUser!.email,
    password: user.password,
  );

  await DatabaseHelper.instance.addUser(matchedUser!);
  await _userService.saveCredentials(
    matchedUser.username,
    matchedUser.password,
    matchedUser.id!,
  );
  user = matchedUser;
  resultMsg = localizations.loginSucessMsg;
} on FirebaseAuthException catch (e) {
  resultMsg = e.message ?? localizations.loginFailedMsg;
}

    }
    notifyListeners();
  }
Future<bool> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
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
          user.id!,
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
            await _userService.getUserById(int.parse(credentials['userid']!));

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
