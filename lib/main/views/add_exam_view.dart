import 'package:flutter/material.dart';

class AddExamView extends StatelessWidget {
  const AddExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة امتحان')),
      body: const Center(
        child: Text('صفحة إضافة الامتحان', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
