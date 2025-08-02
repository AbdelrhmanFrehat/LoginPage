import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_portal/auth/viewmodels/login_viewmodel.dart';
import '../Models/Course-model.dart';
import '../services/course_api.dart';

class AddCourseView extends StatefulWidget {
  const AddCourseView({super.key});

  @override
  State<AddCourseView> createState() => _AddCourseViewState();
}

class _AddCourseViewState extends State<AddCourseView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _iconController = TextEditingController();
  double _progress = 0.0;
  CourseStatus _selectedStatus = CourseStatus.inProgress;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // ✅ جلب teacherId من Provider
    final teacherId = context
        .read<AuthenticationViewModel>()
        .teacher
        .id
        .toString();

    final course = Course(
      teacherId: teacherId,
      title: _titleController.text.trim(),
      icon: _iconController.text.trim(),
      progress: _progress,
      status: _selectedStatus,
    );

    setState(() => _isLoading = true);

    try {
      final createdCourse = await CourseApi().create(course);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Course added: ${createdCourse.title}')),
      );
      Navigator.pop(context); // بعد الإضافة، ارجع للخلف
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Failed to add course: $e')));
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Course Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _iconController,
                decoration: InputDecoration(labelText: 'Icon (emoji like 📚)'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<CourseStatus>(
                value: _selectedStatus,
                items: CourseStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.name),
                  );
                }).toList(),
                onChanged: (status) =>
                    setState(() => _selectedStatus = status!),
                decoration: InputDecoration(labelText: 'Status'),
              ),
              SizedBox(height: 12),
              Text("Progress: ${(_progress * 100).toInt()}%"),
              Slider(
                value: _progress,
                onChanged: (val) => setState(() => _progress = val),
                min: 0,
                max: 1,
                divisions: 10,
                label: '${(_progress * 100).toInt()}%',
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text('Add Course'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
