import 'package:flutter/material.dart';
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

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String resultMsg = "";

  bool obscurePassword = true;
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Teacher? teacher;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> register() async {
    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        phoneController.text.isEmpty) {
      resultMsg = "الرجاء إكمال جميع الحقول المطلوبة.";
      notifyListeners();
      return;
    }

    _setLoading(true);

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = userCredential.user;
      if (user != null) {
        teacher = Teacher(
          id: user.uid,
          fullName: fullNameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
        );

        await _teacherService.saveTeacherData(teacher!);

        resultMsg = "✅ تم تسجيل الحساب بنجاح!";
      }
    } on FirebaseAuthException catch (e) {
      resultMsg = e.message ?? "❌ فشل التسجيل";
    } catch (e) {
      resultMsg = "❌ حدث خطأ غير متوقع.";
    }

    _setLoading(false);
  }

  Future<bool> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      resultMsg = "الرجاء إدخال البريد الإلكتروني وكلمة المرور.";
      notifyListeners();
      return false;
    }

    _setLoading(true);

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = userCredential.user;
      if (user != null) {
        teacher = await _teacherService.getTeacherById(user.uid);

        if (teacher != null) {
          resultMsg = "✅ تسجيل الدخول ناجح";
          _setLoading(false);
          await _storage.write(
            key: 'email',
            value: emailController.text.trim(),
          );
          await _storage.write(
            key: 'password',
            value: passwordController.text.trim(),
          );
          return true;
        } else {
          resultMsg = "❌ لم يتم العثور على بيانات لهذا المستخدم.";
        }
      }
    } on FirebaseAuthException catch (e) {
      resultMsg = e.code == 'user-not-found' || e.code == 'wrong-password'
          ? "❌ البريد الإلكتروني أو كلمة المرور غير صحيحة."
          : (e.message ?? "❌ فشل تسجيل الدخول");
    } catch (e) {
      resultMsg = "❌ حدث خطأ غير متوقع.";
    }

    _setLoading(false);
    return false;
  }

  Future<bool> authenticateWithBiometrics() async {
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');
    if (email == null || password == null) {
      resultMsg = "الرجاء تسجيل الدخول مرة واحدة على الأقل لتفعيل البصمة.";
      return false;
    }

    final localAuth = LocalAuthentication();
    try {
      final canCheck = await localAuth.canCheckBiometrics;
      if (!canCheck) return false;

      final authenticated = await localAuth.authenticate(
        localizedReason: 'الرجاء تأكيد هويتك بالبصمة',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        emailController.text = email;
        passwordController.text = password;
        return await login();
      }
    } catch (e) {
      print("❌ Biometric auth error: $e");
    }
    return false;
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    await _storage.deleteAll();
    teacher = null;
    notifyListeners();

    Future.microtask(() {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginView()),
        (route) => false,
      );
    });
  }

  Future<void> updateProfile(String newFullName, String newPhone) async {
    if (teacher == null) return;

    final updatedTeacher = Teacher(
      id: teacher!.id,
      fullName: newFullName,
      email: teacher!.email,
      phone: newPhone,
    );

    await _teacherService.updateTeacherData(updatedTeacher);

    teacher = updatedTeacher;
    notifyListeners();
  }

  void disposeControllers() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
  }
}
