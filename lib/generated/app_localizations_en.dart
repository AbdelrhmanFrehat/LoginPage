// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Teacher Portal';

  @override
  String get login => 'Login';

  @override
  String get welcome => 'Welcome';

  @override
  String get errorFirebaseInit => 'Failed to initialize Firebase ';

  @override
  String get appCrashMessage => 'An error occurred while starting the app ';

  @override
  String assignmentDetailsTitle(Object title) {
    return 'Assignment: $title';
  }

  @override
  String editGradeFor(Object studentName) {
    return 'Edit Grade for $studentName';
  }

  @override
  String get enterGrade => 'Enter grade (0-100)';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get noStudentsEnrolled => 'No students enrolled in this course yet.';

  @override
  String get submitted => 'Submitted';

  @override
  String get notSubmitted => 'Not Submitted';

  @override
  String student(Object studentName) {
    return 'Student: $studentName';
  }

  @override
  String get grade => 'Grade';

  @override
  String get noGrade => 'No grade';

  @override
  String get submissionDate => 'Date';

  @override
  String get didNotSubmit => 'Did not submit';

  @override
  String get courseDetails => 'Course Details';

  @override
  String get overallProgress => 'Overall Course Progress';

  @override
  String get enrolledStudents => 'Enrolled Students';

  @override
  String get assignments => 'Assignments';

  @override
  String get exams => 'Exams';

  @override
  String get sendNotification => 'Send Notification';

  @override
  String get messageHint => 'Type your message...';

  @override
  String get sendTo => 'Send to';

  @override
  String get allStudents => 'All Students';

  @override
  String get submittedOnly => 'Submitted Only';

  @override
  String get notSubmittedOnly => 'Not Submitted Only';

  @override
  String get addAssignment => 'Add Assignment';

  @override
  String get addExam => 'Add Exam';

  @override
  String get title => 'Title';

  @override
  String get selectDueDate => 'Select Due Date';

  @override
  String get add => 'Add';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get confirmDeleteAssignment =>
      'Are you sure you want to delete this assignment?';

  @override
  String get confirmDeleteExam => 'Are you sure you want to delete this exam?';

  @override
  String submissionsCount(Object submittedCount, Object totalCount) {
    return '$submittedCount/$totalCount submissions';
  }

  @override
  String get examTitle => 'Exam Title';

  @override
  String get pickDate => 'Pick Date';

  @override
  String get pickStartTime => 'Pick Start Time';

  @override
  String get pickEndTime => 'Pick End Time';

  @override
  String get questions => 'Questions';

  @override
  String get addQuestion => 'Add Question';

  @override
  String get submitExam => 'Submit Exam';

  @override
  String get pleaseCompleteAllFields =>
      'Please complete all fields and add at least one question.';

  @override
  String get questionText => 'Question Text';

  @override
  String get points => 'Points';

  @override
  String get questionType => 'Question Type';

  @override
  String get textAnswer => 'Text Answer';

  @override
  String get trueFalse => 'True / False';

  @override
  String get multipleChoice => 'Multiple Choice';

  @override
  String get answerTrue => 'True';

  @override
  String get answerFalse => 'False';

  @override
  String option(Object number) {
    return 'Option $number';
  }

  @override
  String get addOption => 'Add Option';

  @override
  String get step1_examDetails => 'Exam Details';

  @override
  String get step2_addQuestions => 'Add Questions';

  @override
  String get step3_review => 'Review & Submit';

  @override
  String get continue_ => 'Continue';

  @override
  String get back => 'Back';

  @override
  String examSubmissionsTitle(Object title) {
    return 'Submissions - $title';
  }

  @override
  String get noSubmissionsYet => 'No submissions yet.';

  @override
  String gradeValue(Object grade) {
    return 'Grade: $grade';
  }

  @override
  String get notGraded => 'Grade: Not Graded';

  @override
  String get studentAnswer => 'Student\'s Answer';

  @override
  String get correctAnswer => 'Correct Answer';

  @override
  String get pointsAwarded => 'Points Awarded';

  @override
  String questionNumber(Object number) {
    return 'Question $number';
  }

  @override
  String get totalGrade => 'Total Grade';

  @override
  String get calculateAndSave => 'Calculate & Save Grade';

  @override
  String gradeStudentTitle(Object studentName) {
    return 'Grade: $studentName';
  }

  @override
  String studentId(Object id) {
    return 'Student ID: $id';
  }

  @override
  String get invalidGrade => 'Invalid grade. Please enter a number.';

  @override
  String get gradeSaved => 'Grade saved successfully!';

  @override
  String get saveGrade => 'Save Grade';
}
