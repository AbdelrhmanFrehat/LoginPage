import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:teacher_portal/auth/views/login_view.dart';
import 'package:teacher_portal/database/models/teacher_model.dart';
import '../services/teacher_service.dart';
import 'package:local_auth/local_auth.dart';

class AuthenticationViewModel extends ChangeNotifier {
  final _teacherService = TeacherService();
  final _auth = FirebaseAuth.instance;
  final _storage = const FlutterSecureStorage();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  bool isRegister = false;
  String resultMsg = "";

  bool obscurePassword = true;
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Teacher teacher = Teacher(
    id: 0,
    fullName: '',
    email: '',
    phone: '',
    password: '',
  );

  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<void> loginOrRegister() async {
    teacher = Teacher(
      id: DateTime.now().millisecondsSinceEpoch,
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (teacher.email.isEmpty || teacher.password.isEmpty) {
      resultMsg = "الرجاء إدخال البريد الإلكتروني وكلمة المرور";
      notifyListeners();
      return;
    }

    final hashedPassword = hashPassword(teacher.password);

    if (isRegister) {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: teacher.email,
          password: teacher.password,
        );

        teacher = Teacher(
          id: teacher.id,
          fullName: teacher.fullName,
          email: teacher.email,
          phone: teacher.phone,
          password: hashedPassword,
        );

        await _teacherService.register(teacher);
        await saveCredentials(teacher.email, hashedPassword);

        resultMsg = "✅ تم تسجيل الأستاذ بنجاح!";
        isRegister = false;
      } on FirebaseAuthException catch (e) {
        resultMsg = e.message ?? "❌ فشل التسجيل";
      }
    } else {
      final foundTeacher = await _teacherService.getByEmail(teacher.email);
      if (foundTeacher != null && foundTeacher.password == hashedPassword) {
        resultMsg = "✅ تسجيل الدخول ناجح";
        teacher = foundTeacher;
        await saveCredentials(teacher.email, hashedPassword);
      } else {
        resultMsg = "❌ البريد الإلكتروني أو كلمة المرور غير صحيحة";
      }
    }

    notifyListeners();
  }

  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'password', value: password);
  }

  Future<Map<String, String?>> getCredentials() async {
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');
    return {'email': email, 'password': password};
  }

  Future<bool> loginWithBiometrics() async {
    final creds = await getCredentials();
    final email = creds['email'];
    final password = creds['password'];
    if (email != null && password != null) {
      final foundTeacher = await _teacherService.getByEmail(email);
      if (foundTeacher != null && foundTeacher.password == password) {
        teacher = foundTeacher;
        resultMsg = "✅ تسجيل الدخول بالبصمة ناجح";
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<void> logout(BuildContext context) async {
    await _storage.deleteAll();
    teacher = Teacher(id: 0, fullName: '', email: '', phone: '', password: '');
    notifyListeners();

    Future.microtask(() {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginView()),
        (route) => false,
      );
    });
  }

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticateWithBiometrics() async {
    try {
      final canCheck = await auth.canCheckBiometrics;
      final supported = await auth.isDeviceSupported();

      if (!canCheck || !supported) return false;

      final authenticated = await auth.authenticate(
        localizedReason: 'الرجاء تأكيد هويتك بالبصمة',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        return await loginWithBiometrics();
      }
    } catch (e) {
      print("❌ Biometric auth error: $e");
    }
    return false;
  }

  void disposeControllers() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }
}
