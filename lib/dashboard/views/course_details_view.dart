import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_portal/dashboard/Models/Course-model.dart';
import 'package:teacher_portal/dashboard/Viewmodels/course_details_viewmodel.dart';
import 'package:teacher_portal/dashboard/views/add_exam_view.dart';
import 'package:teacher_portal/dashboard/views/assignment-details-view.dart';
import 'package:teacher_portal/dashboard/views/exam_submissions_view.dart';
import 'package:teacher_portal/generated/app_localizations.dart';

class CourseDetailsView extends StatelessWidget {
  final Course course;

  const CourseDetailsView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseDetailsViewModel(course: course),
      child: Consumer<CourseDetailsViewModel>(
        builder: (context, viewModel, child) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            appBar: AppBar(
              title: Text(course.title),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
              ],
            ),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildContent(context, viewModel, l10n),
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    CourseDetailsViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: l10n.enrolledStudents),
              Tab(text: l10n.assignments),
              Tab(text: l10n.exams),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildStudentsList(context, viewModel),
                _buildListSection(
                  context,
                  viewModel,
                  l10n,
                  type: 'assignments',
                ),
                _buildListSection(context, viewModel, l10n, type: 'exams'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsList(
    BuildContext context,
    CourseDetailsViewModel viewModel,
  ) {
    if (viewModel.students.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noStudentsEnrolled),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: viewModel.students.length,
      itemBuilder: (context, index) {
        final student = viewModel.students[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(student['name']?.substring(0, 1) ?? 'U'),
            ),
            title: Text(student['name'] ?? ''),
            subtitle: Text(student['email'] ?? ''),
          ),
        );
      },
    );
  }

  Widget _buildListSection(
    BuildContext context,
    CourseDetailsViewModel viewModel,
    AppLocalizations l10n, {
    required String type,
  }) {
    final items = type == 'assignments'
        ? viewModel.assignments
        : viewModel.exams;
    final onAdd = type == 'assignments'
        ? () => _addAssignmentDialog(context, viewModel, l10n)
        : () => _addExam(context, viewModel);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: onAdd,
        child: const Icon(Icons.add),
      ),
      body: items.isEmpty
          ? Center(child: Text('No ${type} added yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildListItemCard(context, viewModel, l10n, item, type);
              },
            ),
    );
  }

  Widget _buildListItemCard(
    BuildContext context,
    CourseDetailsViewModel viewModel,
    AppLocalizations l10n,
    Map<String, dynamic> item,
    String type,
  ) {
    final totalStudents = viewModel.course.enrolledStudents.length;
    final submissionsRaw = item["submissions"];
    final submissionsCount = submissionsRaw is Map ? submissionsRaw.length : 0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(type == 'assignments' ? Icons.assignment : Icons.quiz),
        ),
        title: Text(item["title"] ?? ''),
        subtitle: Text(
          l10n.submissionsCount(
            submissionsCount.toString(),
            totalStudents.toString(),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () =>
              _confirmDeleteDialog(context, viewModel, l10n, item['id'], type),
        ),
        onTap: () {
          if (type == 'assignments') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AssignmentDetailsView(
                  courseId: viewModel.course.id!,
                  assignmentId: item["id"],
                  title: item["title"],
                  enrolledStudents: viewModel.students,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ExamSubmissionsView(
                  courseId: viewModel.course.id!,
                  examId: item["id"],
                  title: item["title"] ?? '',
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _addAssignmentDialog(
    BuildContext context,
    CourseDetailsViewModel viewModel,
    AppLocalizations l10n,
  ) async {
    final titleController = TextEditingController();
    DateTime? dueDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(l10n.addAssignment),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: l10n.title),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(l10n.selectDueDate),
                  // تحقق أولاً إذا كان dueDate لا يساوي null
                  subtitle: Text(
                    dueDate != null
                        ? dueDate!.toIso8601String().split('T')[0]
                        : 'No date selected',
                  ), // أو أي نص افتراضي آخر
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: dueDate!,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setDialogState(() => dueDate = pickedDate);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty && dueDate != null) {
                    await viewModel.addAssignment(
                      titleController.text,
                      dueDate!,
                    );
                    Navigator.pop(dialogContext);
                  }
                },
                child: Text(l10n.add),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _addExam(
    BuildContext context,
    CourseDetailsViewModel viewModel,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddExamView(courseId: viewModel.course.id!),
      ),
    );
    viewModel.loadAssignmentsAndExams(); // Refresh after returning
  }

  Future<void> _confirmDeleteDialog(
    BuildContext context,
    CourseDetailsViewModel viewModel,
    AppLocalizations l10n,
    String id,
    String type,
  ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(
          type == 'assignments'
              ? l10n.confirmDeleteAssignment
              : l10n.confirmDeleteExam,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      if (type == 'assignments') {
        await viewModel.deleteAssignment(id);
      } else {
        await viewModel.deleteExam(id);
      }
    }
  }
}
