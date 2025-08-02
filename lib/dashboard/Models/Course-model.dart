import 'package:flutter/material.dart';

enum CourseStatus { inProgress, completed, upcoming, overdue }

class Course {
  final String? id; // Firebase key
  final String teacherId; // ⬅️ ربط الأستاذ بالكورس
  final String icon;
  final String title;
  final CourseStatus status;
  final double progress;

  const Course({
    this.id,
    required this.teacherId,
    required this.icon,
    required this.title,
    required this.status,
    required this.progress,
  });

  factory Course.fromMap(Map<String, dynamic> map, String id) {
    return Course(
      id: id,
      teacherId: map['teacherId'] ?? '',
      icon: map['icon'] as String,
      title: map['title'] as String,
      progress: (map['progress'] as num).toDouble(),
      status: CourseStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => CourseStatus.upcoming,
      ),
    );
  }

  Course copyWith({
    String? id,
    String? teacherId,
    String? icon,
    String? title,
    CourseStatus? status,
    double? progress,
  }) {
    return Course(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'teacherId': teacherId,
      'icon': icon,
      'title': title,
      'progress': progress,
      'status': status.name,
    };
  }
}
