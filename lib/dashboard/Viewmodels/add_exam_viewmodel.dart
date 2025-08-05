import 'package:flutter/material.dart';
import 'package:teacher_portal/database/models/exam_model.dart';
import 'package:teacher_portal/database/models/exam_question_model.dart';
import 'package:teacher_portal/firebase_database_service.dart';

class AddExamViewModel extends ChangeNotifier {
  final String courseId;
  final _db = FirebaseDatabaseService();

  AddExamViewModel({required this.courseId});

  int _currentStep = 0;
  int get currentStep => _currentStep;

  final formKeyStep1 = GlobalKey<FormState>();
  final titleController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  List<ExamQuestion> questions = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void onStepTapped(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void onStepContinue() {
    if (_currentStep == 0) {
      if (formKeyStep1.currentState!.validate()) {
        _currentStep++;
      }
    } else if (_currentStep < 2) {
      _currentStep++;
    }
    notifyListeners();
  }

  void onStepCancel() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void setStartTime(TimeOfDay time) {
    startTime = time;
    notifyListeners();
  }

  void setEndTime(TimeOfDay time) {
    endTime = time;
    notifyListeners();
  }

  void addQuestion(ExamQuestion question) {
    questions.add(question);
    notifyListeners();
  }

  void removeQuestionAt(int index) {
    questions.removeAt(index);
    notifyListeners();
  }

  Future<bool> submitExam() async {
    if (titleController.text.isEmpty ||
        selectedDate == null ||
        startTime == null ||
        endTime == null ||
        questions.isEmpty) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    final exam = Exam(
      courseId: courseId,
      title: titleController.text,
      date: selectedDate!,
      startTime: startTime!,
      endTime: endTime!,
      questions: questions,
    );

    try {
      final ref = _db.ref('courses/$courseId/exams').push();
      await ref.set(exam.toMap());
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("Error submitting exam: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
}
