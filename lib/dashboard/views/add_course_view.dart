import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_portal/auth/viewmodels/login_viewmodel.dart';
import 'package:teacher_portal/dashboard/Models/Course-model.dart';
import 'package:teacher_portal/dashboard/viewmodels/add_course_viewmodel.dart';
import 'package:teacher_portal/generated/app_localizations.dart';

class AddCourseView extends StatelessWidget {
  const AddCourseView({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.read<AuthenticationViewModel>();
    final l10n = AppLocalizations.of(context)!;

    return ChangeNotifierProvider(
      create: (_) => AddCourseViewModel(authViewModel: authViewModel),
      child: Consumer<AddCourseViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.addNewCourse)),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: viewModel.titleController,
                      decoration: InputDecoration(
                        labelText: l10n.courseTitle,
                        hintText: l10n.courseTitleHint,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? l10n.fieldRequired : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: viewModel.iconController,
                      decoration: InputDecoration(
                        labelText: l10n.icon,
                        hintText: l10n.iconHint,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? l10n.fieldRequired : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<CourseStatus>(
                      value: viewModel.selectedStatus,
                      items: CourseStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.name),
                        );
                      }).toList(),
                      onChanged: viewModel.setStatus,
                      decoration: InputDecoration(
                        labelText: l10n.status,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text("${l10n.progress}: ${(viewModel.progress * 100).toInt()}%", style: Theme.of(context).textTheme.titleMedium),
                    Slider(
                      value: viewModel.progress,
                      onChanged: viewModel.setProgress,
                      min: 0,
                      max: 1,
                      divisions: 10,
                      label: '${(viewModel.progress * 100).toInt()}%',
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: viewModel.isLoading ? null : () async {
                        final result = await viewModel.submitCourse();
                        if (!context.mounted) return;

                        if (result.startsWith('Error:')) {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result), backgroundColor: Colors.red));
                        } else if (result.isNotEmpty) {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.courseAddedSuccess(result)), backgroundColor: Colors.green));
                           Navigator.pop(context);
                        }
                      },
                      child: viewModel.isLoading
                          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : Text(l10n.addCourse, style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}