import 'package:flutter/material.dart';
import 'package:teacher_portal/database/models/exam_question_model.dart';

class Exam {
  final String? id;
  final String courseId;
  final String title;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final List<ExamQuestion> questions;
  final Map<String, dynamic>? submissions;

  Exam({
    this.id,
    required this.courseId,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.questions,
    this.submissions,
  });

  factory Exam.fromMap(
    Map<String, dynamic> data, {
    required String id,
    required String courseId,
  }) {
    return Exam(
      id: id,
      courseId: courseId,
      title: data['title'],
      date: DateTime.parse(data['date']),
      startTime: _parseTime(data['startTime']),
      endTime: _parseTime(data['endTime']),
      questions: (data['questions'] as List)
          .map((q) => ExamQuestion.fromMap(q))
          .toList(),
      submissions: data['submissions'] != null
          ? Map<String, dynamic>.from(data['submissions'])
          : {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'startTime': _timeToString(startTime),
      'endTime': _timeToString(endTime),
      'questions': questions.map((q) => q.toMap()).toList(),
      if (submissions != null) 'submissions': submissions,
    };
  }

  int get submittedCount => submissions?.length ?? 0;

  static TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String _timeToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
