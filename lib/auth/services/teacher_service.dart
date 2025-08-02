import 'package:firebase_database/firebase_database.dart';
import 'package:teacher_portal/database/models/teacher_model.dart';
import 'package:teacher_portal/firebase_database_service.dart';

class TeacherService {
  final DatabaseReference _internalRef = FirebaseDatabase.instance.ref(
    "teachers",
  );
  final DatabaseReference _externalRef = FirebaseDatabaseService().ref(
    "teachers",
  );

  Future<void> register(Teacher teacher) async {
    final newInternalRef = _internalRef.push();
    await newInternalRef.set(teacher.toMap());

    final newExternalRef = _externalRef.push();
    await newExternalRef.set(teacher.toMap());
  }

  Future<Teacher?> getByEmail(String email) async {
    final snapshot = await _internalRef.get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      for (var entry in data.entries) {
        final map = Map<String, dynamic>.from(entry.value);
        if (map['email'] == email) {
          return Teacher.fromMap(map);
        }
      }
    }
    return null;
  }
}
