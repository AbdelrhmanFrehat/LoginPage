import 'package:flutter/material.dart';
import 'package:teacher_portal/auth/viewmodels/login_viewmodel.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final AuthenticationViewModel viewModel = AuthenticationViewModel();

  @override
  void dispose() {
    viewModel.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إنشاء حساب")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            TextField(
              controller: viewModel.fullNameController,
              decoration: InputDecoration(labelText: "الاسم الكامل"),
            ),
            SizedBox(height: 12),
            TextField(
              controller: viewModel.emailController,
              decoration: InputDecoration(labelText: "البريد الإلكتروني"),
            ),
            SizedBox(height: 12),
            TextField(
              controller: viewModel.passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "كلمة المرور"),
            ),
            SizedBox(height: 12),
            TextField(
              controller: viewModel.phoneController,
              decoration: InputDecoration(labelText: "رقم الهاتف"),
            ),
            SizedBox(height: 12),
            TextField(
              controller: viewModel.addressController,
              decoration: InputDecoration(labelText: "العنوان"),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                viewModel.isRegister = true;
                await viewModel.loginOrRegister();

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(viewModel.resultMsg)));

                if (viewModel.resultMsg.contains("✅")) {
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text("تسجيل"),
            ),
          ],
        ),
      ),
    );
  }
}
