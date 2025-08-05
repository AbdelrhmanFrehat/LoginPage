// lib/dashboard/views/main_page_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_portal/auth/viewmodels/login_viewmodel.dart';
import '../Models/Course-model.dart';
import '../services/course_api.dart';
import 'add_course_view.dart';
import 'course_details_view.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({super.key});

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Course>> _fetchCourses(String teacherId) {
    return CourseApi().readAll(teacherId);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _myCoursesSection(),
        const SizedBox(height: 20),
        _upcomingAssignmentsSection(),
        const SizedBox(height: 20),
        _todaySummarySection(),
        const SizedBox(height: 20),
        _examsSection(),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _myCoursesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          "My Courses",
          trailing: ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddCourseView()),
              );
              setState(() {});
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("+ Add New Course"),
          ),
        ),
        const SizedBox(height: 10),
        FutureBuilder<List<Course>>(
          future: _fetchCourses(
            context.watch<AuthenticationViewModel>().teacher?.id ?? '',
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("❌ Error loading courses: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("لا توجد كورسات مضافة بعد.");
            }

            final courses = snapshot.data!;
            return Column(
              children: courses.map((course) => _courseCard(course)).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _courseCard(Course course) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CourseDetailsView(course: course),
            ),
          );
        },
        leading: Text(course.icon, style: const TextStyle(fontSize: 24)),
        title: Text(course.title),
        subtitle: Text(course.status.name),
        trailing: SizedBox(
          width: 60,
          child: LinearProgressIndicator(
            value: course.progress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      ),
    );
  }

  // الدوال المساعدة تبقى كما هي...
  Widget _upcomingAssignmentsSection() {
    final assignments = [
      {
        "title": "Essay: Industrial Revolution",
        "course": "World History",
        "progress": 75,
      },
      {"title": "Chapter 5 Problem Set", "course": "Algebra I", "progress": 50},
      {
        "title": "Lab Report: Chemistry",
        "course": "Chemistry Basics",
        "progress": 20,
      },
      {
        "title": "Problem Solving: Kinematics",
        "course": "Physics",
        "progress": 0,
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Upcoming Assignments"),
        const SizedBox(height: 10),
        ...assignments.map((assignment) => _assignmentCard(assignment)),
      ],
    );
  }

  Widget _assignmentCard(Map<String, dynamic> assignment) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.assignment, color: Colors.orange),
        title: Text(assignment["title"]),
        subtitle: Text(assignment["course"]),
        trailing: SizedBox(
          width: 60,
          child: LinearProgressIndicator(
            value: (assignment["progress"] / 100),
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      ),
    );
  }

  Widget _todaySummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Today's Summary"),
        const SizedBox(height: 10),
        Row(
          children: [
            _summaryCard("Pending Assignments", 3),
            const SizedBox(width: 16),
            _summaryCard("Scheduled Exams", 1),
          ],
        ),
      ],
    );
  }

  Widget _summaryCard(String label, int count) {
    return Expanded(
      child: Card(
        color: Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(label),
              const SizedBox(height: 8),
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  count.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _examsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Exams"),
        const SizedBox(height: 10),
        _examGroup("Upcoming Exams", [
          _examCard("Midterm Exam", "Algebra I", "Nov 25", "Upcoming"),
          _examCard("Unit 3 Test", "Chemistry Basics", "Nov 28", "Upcoming"),
        ]),
        _examGroup("Active Exams", [
          _examCard("Quiz: WWII Causes", "World History", "Nov 10", "Active"),
        ]),
        _examGroup("Completed Exams", [
          _examCard("Chapter 1 Quiz", "Physics", "Nov 5", "Completed"),
          _examCard("Intro to Linear", "Algebra I", "Oct 28", "Completed"),
        ]),
      ],
    );
  }

  Widget _examGroup(String title, List<Widget> exams) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...exams,
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _examCard(String title, String course, String date, String status) {
    Color statusColor = status == "Active"
        ? Colors.green
        : status == "Completed"
        ? Colors.grey
        : Colors.blue;
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(course),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(date, style: const TextStyle(color: Colors.grey)),
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(color: statusColor, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, {Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (trailing != null) trailing,
      ],
    );
  }
}
