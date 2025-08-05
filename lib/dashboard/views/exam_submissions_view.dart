// lib/dashboard/views/exam_submissions_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_portal/dashboard/views/grade_exam_view.dart';
import 'package:teacher_portal/dashboard/viewmodels/exam_submissions_viewmodel.dart';
import 'package:teacher_portal/generated/app_localizations.dart';

class ExamSubmissionsView extends StatelessWidget {
  final String courseId;
  final String examId;
  final String title;

  const ExamSubmissionsView({
    super.key,
    required this.courseId,
    required this.examId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ExamSubmissionsViewModel(courseId: courseId, examId: examId),
      child: Consumer<ExamSubmissionsViewModel>(
        builder: (context, viewModel, child) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            appBar: AppBar(title: Text(l10n.examSubmissionsTitle(title))),
            body: _buildBody(context, viewModel, l10n),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ExamSubmissionsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.submissions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              l10n.noSubmissionsYet,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.loadSubmissions,
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: viewModel.submissions.length,
        itemBuilder: (_, index) {
          final submission = viewModel.submissions[index];
          final name =
              viewModel.studentNames[submission.studentId] ?? 'Unknown';
          final hasGrade = submission.grade != null;

          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: hasGrade ? Colors.green : Colors.orange,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                hasGrade
                    ? l10n.gradeValue(submission.grade.toString())
                    : l10n.notGraded,
                style: TextStyle(
                  color: hasGrade
                      ? Colors.green.shade700
                      : Colors.orange.shade800,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                // Navigate and then refresh the list when returning
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GradeExamView(
                      submission: submission,
                      studentName: name,
                    ),
                  ),
                );
                // Refresh data when coming back from the grading screen
                viewModel.loadSubmissions();
              },
            ),
          );
        },
      ),
    );
  }
}
