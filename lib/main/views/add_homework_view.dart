import 'package:flutter/material.dart';

class AddHomeworkView extends StatelessWidget {
  const AddHomeworkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة واجب')),
      body: const Center(
        child: Text('صفحة إضافة الواجب', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
