import 'package:firebase_database/firebase_database.dart';
import 'package:teacher_portal/database/models/teacher_model.dart';

class TeacherService {
  final DatabaseReference _teachersRef = FirebaseDatabase.instance.ref(
    "teachers",
  );

  Future<void> saveTeacherData(Teacher teacher) async {
    if (teacher.id == null) return;
    try {
      await _teachersRef.child(teacher.id!).set(teacher.toMap());
    } catch (e) {
      print("Error saving teacher data: $e");
    }
  }

  Future<Teacher?> getTeacherById(String uid) async {
    try {
      final snapshot = await _teachersRef.child(uid).get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return Teacher.fromMap(data, uid);
      }
    } catch (e) {
      print("Error getting teacher by id: $e");
    }
    return null;
  }

  Future<void> updateTeacherData(Teacher teacher) async {
    if (teacher.id == null) return;
    try {
      await _teachersRef.child(teacher.id!).update({
        'fullName': teacher.fullName,
        'phone': teacher.phone,
      });
    } catch (e) {
      print("Error updating teacher data: $e");
    }
  }
}
