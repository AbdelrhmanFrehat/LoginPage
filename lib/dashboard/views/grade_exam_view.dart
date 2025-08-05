import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_portal/database/models/submission_model.dart';
import 'package:teacher_portal/dashboard/Viewmodels/grade_exam_viewmodel.dart';
import 'package:teacher_portal/generated/app_localizations.dart';

class GradeExamView extends StatelessWidget {
  final Submission submission;
  final String studentName;

  const GradeExamView({
    super.key,
    required this.submission,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GradeExamViewModel(submission: submission),
      child: Consumer<GradeExamViewModel>(
        builder: (context, viewModel, child) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            appBar: AppBar(title: Text(l10n.gradeStudentTitle(studentName))),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildStudentInfoCard(context, viewModel, l10n),
                  const SizedBox(height: 24),
                  _buildSubmissionContentCard(context, viewModel, l10n),
                  const SizedBox(height: 24),
                  _buildGradeInputField(viewModel, l10n),
                  const SizedBox(height: 32),
                  _buildSaveButton(context, viewModel, l10n),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStudentInfoCard(
    BuildContext context,
    GradeExamViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(studentName.substring(0, 1))),
        title: Text(
          studentName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(l10n.studentId(viewModel.submission.studentId)),
      ),
    );
  }

  Widget _buildSubmissionContentCard(
    BuildContext context,
    GradeExamViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.studentAnswer,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 16),
            Text(
              // عرض الـ content هنا
              viewModel.submission.content ?? "No content submitted.",
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeInputField(
    GradeExamViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return TextField(
      controller: viewModel.gradeController,
      decoration: InputDecoration(
        labelText: l10n.grade,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.school),
      ),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    GradeExamViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 18),
      ),
      icon: viewModel.isSaving
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : const Icon(Icons.save),
      label: Text(l10n.saveGrade),
      onPressed: viewModel.isSaving
          ? null
          : () async {
              final success = await viewModel.saveGrade();
              if (!context.mounted) return;
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.gradeSaved),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.invalidGrade),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
    );
  }
}
