import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100),
            const SizedBox(height: 24),
            Text(
              'Teacher Portal',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const Divider(height: 48),
            const Text(
              'This app is designed to help teachers manage their courses, assignments, and students efficiently. Developed with passion using Flutter.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const Spacer(),
            const Text(
              'Developed by Abdelrhman Frehat',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}