enum CourseStatus { inProgress, completed, upcoming, overdue }

class Course {
  final String? id;
  final String teacherId;
  final String icon;
  final String title;
  final CourseStatus status;
  final double progress;
  final Map<String, dynamic> enrolledStudents;
  final int enrolledCount;

  const Course({
    this.id,
    required this.teacherId,
    required this.icon,
    required this.title,
    required this.status,
    required this.progress,
    this.enrolledStudents = const {},
    this.enrolledCount = 0,
  });

  factory Course.fromMap(Map<String, dynamic> map, String id) {
    final studentsMap = map['enrolledStudents'] is Map
        ? Map<String, dynamic>.from(map['enrolledStudents'])
        : <String, dynamic>{};

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
      enrolledStudents: studentsMap,
      enrolledCount: studentsMap.length,
    );
  }

  Course copyWith({
    String? id,
    String? teacherId,
    String? icon,
    String? title,
    CourseStatus? status,
    double? progress,
    Map<String, dynamic>? enrolledStudents,
    int? enrolledCount,
  }) {
    return Course(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      enrolledStudents: enrolledStudents ?? this.enrolledStudents,
      enrolledCount: enrolledCount ?? this.enrolledStudents.length,
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
