import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/user.service.dart';

class AuthenticationViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  bool isRegisterMode = false;
  String resultMsg = "";
  Users user = Users(
      username: '', password: '', fullname: '', email: '', phoneNumber: '');

  void toggleMode() {
    isRegisterMode = !isRegisterMode;
    notifyListeners();
  }

  void clearUser() {
    user = Users(
        username: '', password: '', fullname: '', email: '', phoneNumber: '');
    notifyListeners();
  }

  Future<void> loginOrRegister() async {
    if (isRegisterMode) {
      final exists = await _userService.checkUsernameExists(user.username);
      if (exists) {
        resultMsg = "اسم المستخدم موجود مسبقًا";
        return;
      }
      await _userService.register(user);
      resultMsg = "تم التسجيل بنجاح";
      toggleMode();
    } else {
      final success = await _userService.login(user.username, user.password);
      resultMsg = success ? "تم تسجيل الدخول" : "فشل تسجيل الدخول";
    }
    notifyListeners();
  }

  Future<bool> biometricLogin(String username) async {
    final auth = LocalAuthentication();
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'استخدم بصمتك لتسجيل الدخول',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (authenticated) {
        Users? u = await _userService.getUserByUsername(username);
        return u != null;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
