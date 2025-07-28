import 'package:flutter/material.dart';

class CoursesView extends StatelessWidget {
  const CoursesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الكورسات')),
      body: Center(child: Text('صفحة عرض الكورسات')),
    );
  }
}
