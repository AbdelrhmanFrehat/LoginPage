import 'package:flutter/material.dart';
import 'package:teacher_portal/dashboard/Models/Course-model.dart';
import 'package:teacher_portal/database/models/assignment_model.dart';
import 'package:teacher_portal/database/models/exam_model.dart';
import 'package:teacher_portal/firebase_database_service.dart';

class CourseDetailsView extends StatefulWidget {
  const CourseDetailsView({super.key, required this.course});
  final Course course;

  @override
  State<CourseDetailsView> createState() => _CourseDetailsViewState();
}

class _CourseDetailsViewState extends State<CourseDetailsView> {
  List<Map<String, dynamic>> _assignments = [];
  List<Map<String, dynamic>> _exams = [];

  final _db = FirebaseDatabaseService();

  @override
  void initState() {
    super.initState();
    loadDetails();
  }

  Future<void> loadDetails() async {
    final assignmentsSnap = await _db
        .ref('courses/${widget.course.id}/assignments')
        .get();
    final examsSnap = await _db.ref('courses/${widget.course.id}/exams').get();

    if (assignmentsSnap.exists) {
      final data = Map<String, dynamic>.from(assignmentsSnap.value as Map);
      _assignments = data.entries
          .map((e) => {'id': e.key, ...Map<String, dynamic>.from(e.value)})
          .toList();
    }

    if (examsSnap.exists) {
      final data = Map<String, dynamic>.from(examsSnap.value as Map);
      _exams = data.entries
          .map((e) => {'id': e.key, ...Map<String, dynamic>.from(e.value)})
          .toList();
    }

    setState(() {});
  }

  Future<void> _addAssignment() async {
    String? title;
    DateTime? dueDate;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Assignment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Title"),
              onChanged: (val) => title = val,
            ),
            TextButton(
              child: Text("Select Due Date"),
              onPressed: () async {
                dueDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2030),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (title != null && dueDate != null) {
                final newAssignment = Assignment(
                  title: title!,
                  dueDate: dueDate!.toIso8601String(),
                  submissions: 0,
                );
                final newRef = _db
                    .ref('courses/${widget.course.id}/assignments')
                    .push();
                await newRef.set(newAssignment.toMap());
                loadDetails();
                Navigator.pop(context);
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  Future<void> _addExam() async {
    String? title;
    DateTime? dueDate;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Exam"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Title"),
              onChanged: (val) => title = val,
            ),
            TextButton(
              child: Text("Select Due Date"),
              onPressed: () async {
                dueDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2030),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (title != null && dueDate != null) {
                final newExam = Exam(
                  title: title!,
                  date: dueDate!.toIso8601String(),
                  submitted: 0,
                );
                final newRef = _db
                    .ref('courses/${widget.course.id}/exams')
                    .push();
                await newRef.set(newExam.toMap());
                loadDetails();
                Navigator.pop(context);
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title ?? 'Course Details'),
        actions: [
          IconButton(
            onPressed: () {
              // تعديل الكورس
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Overall Course Progress"),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: 0.65),
            const SizedBox(height: 24),
            const Text(
              "Enrolled Students",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            ..._buildStudentsList(),
            const SizedBox(height: 24),
            _sectionHeader("Assignments", onAdd: _addAssignment),
            ..._buildAssignmentsList(),
            const SizedBox(height: 24),
            _sectionHeader("Exams", onAdd: _addExam),
            ..._buildExamsList(),
            const SizedBox(height: 24),
            const Text(
              "Send Notification",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Type your message...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: "all", child: Text("All Students")),
                DropdownMenuItem(
                  value: "submitted",
                  child: Text("Submitted Only"),
                ),
                DropdownMenuItem(
                  value: "not_submitted",
                  child: Text("Not Submitted Only"),
                ),
              ],
              onChanged: (val) {},
              decoration: const InputDecoration(labelText: "Send to"),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // send notification
              },
              icon: const Icon(Icons.send),
              label: const Text("Send Notification"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, {required VoidCallback onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        IconButton(onPressed: onAdd, icon: const Icon(Icons.add)),
      ],
    );
  }

  List<Widget> _buildStudentsList() {
    final students = [
      {
        "name": "Alice Johnson",
        "email": "alice.j@example.com",
        "progress": 0.8,
        "submitted": true,
      },
      {
        "name": "Bob Smith",
        "email": "bob.s@example.com",
        "progress": 0.5,
        "submitted": false,
      },
      {
        "name": "Carol White",
        "email": "carol.w@example.com",
        "progress": 0.7,
        "submitted": true,
      },
    ];

    return students.map((student) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          title: Text(student["name"]?.toString() ?? ''),
          subtitle: Text(student["email"]?.toString() ?? ''),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                student["submitted"] == true
                    ? "✅ Submitted"
                    : "❌ Not Submitted",
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 80,
                child: LinearProgressIndicator(
                  value: double.tryParse(
                    student["progress"]?.toString() ?? '0',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildAssignmentsList() {
    return _assignments.map((item) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          title: Text(item["title"] ?? ''),
          subtitle: Text(
            "Due: ${item["dueDate"]} - ${item["submissions"]} submissions",
          ),
          trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
        ),
      );
    }).toList();
  }

  List<Widget> _buildExamsList() {
    return _exams.map((item) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          title: Text(item["title"] ?? ''),
          subtitle: Text(
            "Due: ${item["dueDate"]} - ${item["submissions"]} students",
          ),
          trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
        ),
      );
    }).toList();
  }
}
