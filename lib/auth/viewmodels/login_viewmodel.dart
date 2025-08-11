import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
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

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String resultMsg = "";

  bool obscurePassword = true;

  Teacher? teacher;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _updateFcmToken(String teacherId) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;

      final tokenRef = FirebaseDatabase.instance.ref(
        "teachers/$teacherId/fcmTokens",
      );

      await tokenRef.runTransaction((Object? currentData) {
        List<dynamic> tokens = currentData == null
            ? []
            : List<dynamic>.from(currentData as List);
        if (!tokens.contains(token)) {
          tokens.add(token);
        }
        return Transaction.success(tokens);
      });
    } catch (e) {
      print("Failed to update FCM token: $e");
    }
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
        String? fcmToken = await FirebaseMessaging.instance.getToken();

        teacher = Teacher(
          id: user.uid,
          fullName: fullNameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
          fcmTokens: fcmToken != null ? [fcmToken] : [],
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

  Future<void> _syncFcmToken(String teacherId) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        print("ℹ️ FCM token is null, cannot sync.");
        return;
      }
      // استدعاء الخدمة لمزامنة التوكن مع كلا قاعدتي البيانات
      await _teacherService.addFcmToken(teacherId, token);
    } catch (e) {
      // طباعة الخطأ إذا حدثت مشكلة أثناء الحصول على التوكن
      print("❌ Failed to get FCM token to sync: $e");
    }
  }

  // ... (الكود الحالي: register)

  // -->> قم بتعديل دالة login لاستدعاء الدالة الجديدة <<--
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
          // -->> هذا هو التعديل الرئيسي هنا <<--
          // استدعاء الدالة الجديدة التي تتعامل مع كلا قاعدتي البيانات
          await _syncFcmToken(teacher!.id!);

          resultMsg = "✅ تسجيل الدخول ناجح";
          await _storage.write(
            key: 'email',
            value: emailController.text.trim(),
          );
          await _storage.write(
            key: 'password',
            value: passwordController.text.trim(),
          );
          _setLoading(false);
          return true;
        } else {
          resultMsg =
              "❌ المصادقة نجحت ولكن لم يتم العثور على بيانات الملف الشخصي.";
          await _auth.signOut();
        }
      }
    } on FirebaseAuthException catch (e) {
      resultMsg =
          e.code == 'user-not-found' ||
              e.code == 'wrong-password' ||
              e.code == 'invalid-credential'
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
      if (!canCheck) {
        resultMsg = "البصمة غير متاحة على هذا الجهاز.";
        return false;
      }

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
      resultMsg = "❌ فشلت المصادقة بالبصمة.";
      print("Biometric auth error: $e");
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

    final updatedTeacher = teacher!.copyWith(
      fullName: newFullName,
      phone: newPhone,
    );

    await _teacherService.updateTeacherData(updatedTeacher);

    teacher = updatedTeacher;
    notifyListeners();
  }

  
  
  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
