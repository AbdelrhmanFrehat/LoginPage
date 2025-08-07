import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_portal/auth/viewmodels/login_viewmodel.dart';
import 'package:teacher_portal/dashboard/Models/Course-model.dart';
import 'package:teacher_portal/dashboard/Viewmodels/main_page_viewmodel.dart';
import 'package:teacher_portal/dashboard/views/add_course_view.dart';
import 'package:teacher_portal/dashboard/views/course_details_view.dart';
import 'package:teacher_portal/generated/app_localizations.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final teacherId = context.read<AuthenticationViewModel>().teacher?.id;
      if (teacherId != null) {
        context.read<MainPageViewModel>().fetchAllData(teacherId);
      }
    });
  }

  Future<void> _refreshData() async {
    final teacherId = context.read<AuthenticationViewModel>().teacher?.id;
    if (teacherId != null) {
      await context.read<MainPageViewModel>().fetchAllData(teacherId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainPageViewModel>();
    final l10n = AppLocalizations.of(context)!;

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.errorMessage != null) {
      return Center(child: Text(l10n.errorLoadingCourses(viewModel.errorMessage!)));
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _myCoursesSection(context, viewModel, l10n),
          const SizedBox(height: 24),
          _upcomingAssignmentsSection(context, viewModel, l10n),
          const SizedBox(height: 24),
          _todaySummarySection(context, viewModel, l10n),
          const SizedBox(height: 24),
          _examsSection(context, viewModel, l10n),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _myCoursesSection(BuildContext context, MainPageViewModel viewModel, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          l10n.myCourses,
          trailing: ElevatedButton.icon(
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.addNewCourse),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddCourseView()));
              _refreshData(); // Refresh data after adding a new course
            },
          ),
        ),
        if (viewModel.courses.isEmpty)
          Center(child: Padding(padding: const EdgeInsets.all(20.0), child: Text(l10n.noCoursesAdded)))
        else
          ...viewModel.courses.map((course) => _courseCard(context, course)),
      ],
    );
  }

  Widget _courseCard(BuildContext context, Course course) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailsView(course: course)));
          _refreshData();
        },
        leading: Text(course.icon, style: const TextStyle(fontSize: 28)),
        title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: LinearProgressIndicator(
          value: course.progress,
          backgroundColor: Colors.grey[300],
        ),
        trailing: Text("${(course.progress * 100).toInt()}%"),
      ),
    );
  }

  Widget _upcomingAssignmentsSection(BuildContext context, MainPageViewModel viewModel, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(l10n.upcomingAssignments),
        if (viewModel.upcomingAssignments.isEmpty)
          Center(child: Padding(padding: const EdgeInsets.all(20.0), child: Text(l10n.noUpcomingAssignments)))
        else
          ...viewModel.upcomingAssignments.map((assignment) => _assignmentCard(assignment)),
      ],
    );
  }

  Widget _assignmentCard(Map<String, dynamic> assignment) {
    final submissions = assignment['submissions'] is Map ? (assignment['submissions'] as Map).length : 0;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.assignment_late, color: Colors.orange),
        title: Text(assignment["title"]),
        subtitle: Text(assignment["courseName"]),
        trailing: Text("$submissions submissions"),
      ),
    );
  }

  Widget _todaySummarySection(BuildContext context, MainPageViewModel viewModel, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(l10n.todaysSummary),
        Row(
          children: [
            _summaryCard(l10n.pendingAssignments, viewModel.upcomingAssignments.length, Icons.assignment, Colors.orange),
            const SizedBox(width: 16),
            _summaryCard(l10n.scheduledExams, viewModel.upcomingExams.length, Icons.quiz, Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _summaryCard(String label, int count, IconData icon, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
              const SizedBox(height: 8),
              Text(count.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _examsSection(BuildContext context, MainPageViewModel viewModel, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(l10n.exams),
        if (viewModel.allExams.isEmpty)
           Center(child: Padding(padding: const EdgeInsets.all(20.0), child: Text(l10n.noExamsScheduled)))
        else ...[
          _examGroup(l10n.upcoming, viewModel.upcomingExams, Colors.blue),
          _examGroup(l10n.active, viewModel.activeExams, Colors.green),
          _examGroup(l10n.completed, viewModel.completedExams, Colors.grey),
        ]
      ],
    );
  }

  Widget _examGroup(String title, List<Map<String, dynamic>> exams, Color color) {
    if (exams.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
        ),
        ...exams.map((exam) => _examCard(exam, color)),
      ],
    );
  }

  Widget _examCard(Map<String, dynamic> exam, Color statusColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(exam["title"]),
        subtitle: Text(exam["courseName"]),
        trailing: Text(exam['date']?.toString().split('T')[0] ?? ''),
      ),
    );
  }
}