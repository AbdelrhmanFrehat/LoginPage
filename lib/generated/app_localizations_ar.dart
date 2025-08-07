// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'بوابة المعلمين';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get welcome => 'أهلاً وسهلاً';

  @override
  String get errorFirebaseInit => 'فشل في تهيئة Firebase ';

  @override
  String get appCrashMessage => 'حدث خطأ أثناء بدء التطبيق ';

  @override
  String assignmentDetailsTitle(Object title) {
    return 'تفاصيل الواجب: $title';
  }

  @override
  String editGradeFor(Object studentName) {
    return 'تعديل درجة الطالب: $studentName';
  }

  @override
  String get enterGrade => 'أدخل الدرجة (0-100)';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get noStudentsEnrolled => 'لا يوجد طلاب مسجلون في هذا الكورس بعد.';

  @override
  String get submitted => 'قاموا بالتسليم';

  @override
  String get notSubmitted => 'لم يقوموا بالتسليم';

  @override
  String student(Object studentName) {
    return 'الطالب: $studentName';
  }

  @override
  String get grade => 'الدرجة';

  @override
  String get noGrade => 'لا توجد درجة';

  @override
  String get submissionDate => 'التاريخ';

  @override
  String get didNotSubmit => 'لم يقم بالتسليم';

  @override
  String get courseDetails => 'تفاصيل الكورس';

  @override
  String get overallProgress => 'التقدم العام للكورس';

  @override
  String get enrolledStudents => 'الطلاب المسجلون';

  @override
  String get assignments => 'الواجبات';

  @override
  String get exams => 'الاختبارات';

  @override
  String get sendNotification => 'إرسال إشعار';

  @override
  String get messageHint => 'اكتب رسالتك...';

  @override
  String get sendTo => 'إرسال إلى';

  @override
  String get allStudents => 'كل الطلاب';

  @override
  String get submittedOnly => 'الذين سلموا فقط';

  @override
  String get notSubmittedOnly => 'الذين لم يسلموا فقط';

  @override
  String get addAssignment => 'إضافة واجب';

  @override
  String get addExam => 'إضافة اختبار';

  @override
  String get title => 'العنوان';

  @override
  String get selectDueDate => 'اختر تاريخ التسليم';

  @override
  String get add => 'إضافة';

  @override
  String get delete => 'حذف';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get confirmDeleteAssignment =>
      'هل أنت متأكد من رغبتك في حذف هذا الواجب؟';

  @override
  String get confirmDeleteExam => 'هل أنت متأكد من رغبتك في حذف هذا الاختبار؟';

  @override
  String submissionsCount(Object submittedCount, Object totalCount) {
    return '$submittedCount من $totalCount تسليمات';
  }

  @override
  String get examTitle => 'عنوان الاختبار';

  @override
  String get pickDate => 'اختر التاريخ';

  @override
  String get pickStartTime => 'اختر وقت البدء';

  @override
  String get pickEndTime => 'اختر وقت الانتهاء';

  @override
  String get questions => 'الأسئلة';

  @override
  String get addQuestion => 'إضافة سؤال';

  @override
  String get submitExam => 'إرسال الاختبار';

  @override
  String get pleaseCompleteAllFields =>
      'الرجاء إكمال جميع الحقول وإضافة سؤال واحد على الأقل.';

  @override
  String get questionText => 'نص السؤال';

  @override
  String get points => 'النقاط';

  @override
  String get questionType => 'نوع السؤال';

  @override
  String get textAnswer => 'إجابة نصية';

  @override
  String get trueFalse => 'صح / خطأ';

  @override
  String get multipleChoice => 'اختيار من متعدد';

  @override
  String get answerTrue => 'صح';

  @override
  String get answerFalse => 'خطأ';

  @override
  String option(Object number) {
    return 'خيار $number';
  }

  @override
  String get addOption => 'إضافة خيار';

  @override
  String get step1_examDetails => 'تفاصيل الاختبار';

  @override
  String get step2_addQuestions => 'إضافة الأسئلة';

  @override
  String get step3_review => 'مراجعة وإرسال';

  @override
  String get continue_ => 'متابعة';

  @override
  String get back => 'رجوع';

  @override
  String examSubmissionsTitle(Object title) {
    return 'تسليمات - $title';
  }

  @override
  String get noSubmissionsYet => 'لا توجد تسليمات بعد.';

  @override
  String gradeValue(Object grade) {
    return 'الدرجة: $grade';
  }

  @override
  String get notGraded => 'الدرجة: لم يتم التقييم';

  @override
  String get studentAnswer => 'إجابة الطالب';

  @override
  String get correctAnswer => 'الإجابة الصحيحة';

  @override
  String get pointsAwarded => 'النقاط الممنوحة';

  @override
  String questionNumber(Object number) {
    return 'سؤال $number';
  }

  @override
  String get totalGrade => 'الدرجة الإجمالية';

  @override
  String get calculateAndSave => 'حساب وحفظ الدرجة';

  @override
  String gradeStudentTitle(Object studentName) {
    return 'تقييم: $studentName';
  }

  @override
  String studentId(Object id) {
    return 'هوية الطالب: $id';
  }

  @override
  String get invalidGrade => 'درجة غير صالحة. الرجاء إدخال رقم.';

  @override
  String get gradeSaved => 'تم حفظ الدرجة بنجاح!';

  @override
  String get saveGrade => 'حفظ الدرجة';

  @override
  String get addNewCourse => 'إضافة كورس جديد';

  @override
  String get courseTitle => 'عنوان الكورس';

  @override
  String get courseTitleHint => 'مثال: الجبر 101';

  @override
  String get icon => 'أيقونة';

  @override
  String get iconHint => 'أدخل رمز تعبيري، مثال: 📚';

  @override
  String get status => 'الحالة';

  @override
  String get progress => 'التقدم';

  @override
  String get addCourse => 'إضافة الكورس';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String courseAddedSuccess(Object title) {
    return 'تمت إضافة الكورس \'$title\' بنجاح!';
  }

  @override
  String courseAddedError(Object error) {
    return 'فشلت إضافة الكورس: $error';
  }

  @override
  String get teacherDataNotFound => 'خطأ: لم يتم العثور على بيانات المعلم.';

  @override
  String get myCourses => 'كورساتي';

  @override
  String get noCoursesAdded => 'لم تتم إضافة أي كورسات بعد.';

  @override
  String errorLoadingCourses(Object error) {
    return 'خطأ في تحميل الكورسات: $error';
  }

  @override
  String get upcomingAssignments => 'الواجبات القادمة';

  @override
  String get noUpcomingAssignments => 'لا توجد واجبات قادمة.';

  @override
  String get todaysSummary => 'ملخص اليوم';

  @override
  String get pendingAssignments => 'واجبات معلقة';

  @override
  String get scheduledExams => 'اختبارات مجدولة';

  @override
  String get noExamsScheduled => 'لا توجد اختبارات مجدولة.';

  @override
  String get upcoming => 'قادم';

  @override
  String get active => 'نشط';

  @override
  String get completed => 'مكتمل';

  @override
  String get keyMetrics => 'المقاييس الرئيسية';

  @override
  String get totalStudents => 'إجمالي الطلاب';

  @override
  String get totalCourses => 'إجمالي الكورسات';

  @override
  String get assignmentsGraded => 'واجبات تم تقييمها';

  @override
  String get examsHeld => 'اختبارات تم عقدها';

  @override
  String get performanceInsights => 'رؤى الأداء';

  @override
  String get assignmentSubmissions => 'تسليمات الواجبات';

  @override
  String get assignmentSubmissionsSubtitle =>
      'نظرة عامة على التسليمات في جميع الكورسات.';

  @override
  String get weekly => 'أسبوعي';

  @override
  String get monthly => 'شهري';

  @override
  String get custom => 'مخصص';
}
