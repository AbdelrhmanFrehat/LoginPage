import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_portal/database/models/submission_model.dart';
import 'package:teacher_portal/dashboard/viewmodels/assignment_details_viewmodel.dart';
import 'package:teacher_portal/generated/app_localizations.dart';

class AssignmentDetailsView extends StatelessWidget {
  final String courseId;
  final String assignmentId;
  final String title;
  final List<Map<String, dynamic>> enrolledStudents;

  const AssignmentDetailsView({
    super.key,
    required this.courseId,
    required this.assignmentId,
    required this.title,
    required this.enrolledStudents,
  });

  @override
  Widget build(BuildContext context) {
    // استخدام ChangeNotifierProvider لتوفير الـ ViewModel لهذه الشاشة فقط
    return ChangeNotifierProvider(
      create: (_) => AssignmentDetailsViewModel(
        courseId: courseId,
        assignmentId: assignmentId,
        enrolledStudents: enrolledStudents,
      ),
      child: Consumer<AssignmentDetailsViewModel>(
        builder: (context, viewModel, child) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.assignmentDetailsTitle(title)),
              backgroundColor: Theme.of(context).cardColor,
              elevation: 1,
            ),
            body: _buildBody(context, viewModel, l10n),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AssignmentDetailsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.submissions.isEmpty && viewModel.notSubmittedIds.isEmpty) {
      return Center(child: Text(l10n.noStudentsEnrolled));
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionHeader(
          l10n.submitted,
          Icons.check_circle,
          Colors.green,
          viewModel.submissions.length,
        ),
        const SizedBox(height: 8),
        ...viewModel.submissions.map(
          (sub) => _buildSubmissionCard(context, sub, viewModel, l10n),
        ),

        if (viewModel.notSubmittedIds.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildSectionHeader(
            l10n.notSubmitted,
            Icons.cancel,
            Colors.red,
            viewModel.notSubmittedIds.length,
          ),
          const SizedBox(height: 8),
          ...viewModel.notSubmittedIds.map(
            (id) => _buildNotSubmittedCard(id, viewModel, l10n),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(
    String title,
    IconData icon,
    Color color,
    int count,
  ) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(
          '$title ($count)',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSubmissionCard(
    BuildContext context,
    Submission sub,
    AssignmentDetailsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    final studentName = viewModel.studentNames[sub.studentId] ?? sub.studentId;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.student(studentName),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(height: 16),
            Text(
              sub.content ?? "No text content submitted.",
              style: TextStyle(color: Colors.grey[700], height: 1.4),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  avatar: const Icon(Icons.calendar_today, size: 16),
                  label: Text(viewModel.formatDateTime(sub.submittedAt)),
                ),
                InkWell(
                  onTap: () => _editGradeDialog(context, sub, viewModel, l10n),
                  borderRadius: BorderRadius.circular(20),
                  child: Chip(
                    backgroundColor: sub.grade != null
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    avatar: Icon(
                      Icons.school,
                      size: 16,
                      color: sub.grade != null ? Colors.green : Colors.orange,
                    ),
                    label: Text(
                      sub.grade != null
                          ? '${l10n.grade}: ${sub.grade}'
                          : l10n.noGrade,
                      style: TextStyle(
                        color: sub.grade != null
                            ? Colors.green.shade800
                            : Colors.orange.shade800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotSubmittedCard(
    String studentId,
    AssignmentDetailsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    final studentName = viewModel.studentNames[studentId] ?? studentId;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.grey[200],
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(Icons.person_off, color: Colors.white),
        ),
        title: Text(
          studentName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          l10n.didNotSubmit,
          style: TextStyle(color: Colors.red.shade700),
        ),
      ),
    );
  }

  Future<void> _editGradeDialog(
    BuildContext context,
    Submission sub,
    AssignmentDetailsViewModel viewModel,
    AppLocalizations l10n,
  ) async {
    final controller = TextEditingController(text: sub.grade?.toString() ?? '');
    final studentName = viewModel.studentNames[sub.studentId] ?? sub.studentId;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editGradeFor(studentName)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.enterGrade,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final grade = int.tryParse(controller.text);
              if (grade != null) {
                await viewModel.updateGrade(sub.id, grade);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
