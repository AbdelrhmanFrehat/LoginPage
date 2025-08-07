import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Teacher Portal'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @errorFirebaseInit.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize Firebase '**
  String get errorFirebaseInit;

  /// No description provided for @appCrashMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while starting the app '**
  String get appCrashMessage;

  /// No description provided for @assignmentDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Assignment: {title}'**
  String assignmentDetailsTitle(Object title);

  /// No description provided for @editGradeFor.
  ///
  /// In en, this message translates to:
  /// **'Edit Grade for {studentName}'**
  String editGradeFor(Object studentName);

  /// No description provided for @enterGrade.
  ///
  /// In en, this message translates to:
  /// **'Enter grade (0-100)'**
  String get enterGrade;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @noStudentsEnrolled.
  ///
  /// In en, this message translates to:
  /// **'No students enrolled in this course yet.'**
  String get noStudentsEnrolled;

  /// No description provided for @submitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submitted;

  /// No description provided for @notSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Not Submitted'**
  String get notSubmitted;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student: {studentName}'**
  String student(Object studentName);

  /// No description provided for @grade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get grade;

  /// No description provided for @noGrade.
  ///
  /// In en, this message translates to:
  /// **'No grade'**
  String get noGrade;

  /// No description provided for @submissionDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get submissionDate;

  /// No description provided for @didNotSubmit.
  ///
  /// In en, this message translates to:
  /// **'Did not submit'**
  String get didNotSubmit;

  /// No description provided for @courseDetails.
  ///
  /// In en, this message translates to:
  /// **'Course Details'**
  String get courseDetails;

  /// No description provided for @overallProgress.
  ///
  /// In en, this message translates to:
  /// **'Overall Course Progress'**
  String get overallProgress;

  /// No description provided for @enrolledStudents.
  ///
  /// In en, this message translates to:
  /// **'Enrolled Students'**
  String get enrolledStudents;

  /// No description provided for @assignments.
  ///
  /// In en, this message translates to:
  /// **'Assignments'**
  String get assignments;

  /// No description provided for @exams.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get exams;

  /// No description provided for @sendNotification.
  ///
  /// In en, this message translates to:
  /// **'Send Notification'**
  String get sendNotification;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get messageHint;

  /// No description provided for @sendTo.
  ///
  /// In en, this message translates to:
  /// **'Send to'**
  String get sendTo;

  /// No description provided for @allStudents.
  ///
  /// In en, this message translates to:
  /// **'All Students'**
  String get allStudents;

  /// No description provided for @submittedOnly.
  ///
  /// In en, this message translates to:
  /// **'Submitted Only'**
  String get submittedOnly;

  /// No description provided for @notSubmittedOnly.
  ///
  /// In en, this message translates to:
  /// **'Not Submitted Only'**
  String get notSubmittedOnly;

  /// No description provided for @addAssignment.
  ///
  /// In en, this message translates to:
  /// **'Add Assignment'**
  String get addAssignment;

  /// No description provided for @addExam.
  ///
  /// In en, this message translates to:
  /// **'Add Exam'**
  String get addExam;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @selectDueDate.
  ///
  /// In en, this message translates to:
  /// **'Select Due Date'**
  String get selectDueDate;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @confirmDeleteAssignment.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this assignment?'**
  String get confirmDeleteAssignment;

  /// No description provided for @confirmDeleteExam.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this exam?'**
  String get confirmDeleteExam;

  /// No description provided for @submissionsCount.
  ///
  /// In en, this message translates to:
  /// **'{submittedCount}/{totalCount} submissions'**
  String submissionsCount(Object submittedCount, Object totalCount);

  /// No description provided for @examTitle.
  ///
  /// In en, this message translates to:
  /// **'Exam Title'**
  String get examTitle;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick Date'**
  String get pickDate;

  /// No description provided for @pickStartTime.
  ///
  /// In en, this message translates to:
  /// **'Pick Start Time'**
  String get pickStartTime;

  /// No description provided for @pickEndTime.
  ///
  /// In en, this message translates to:
  /// **'Pick End Time'**
  String get pickEndTime;

  /// No description provided for @questions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questions;

  /// No description provided for @addQuestion.
  ///
  /// In en, this message translates to:
  /// **'Add Question'**
  String get addQuestion;

  /// No description provided for @submitExam.
  ///
  /// In en, this message translates to:
  /// **'Submit Exam'**
  String get submitExam;

  /// No description provided for @pleaseCompleteAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please complete all fields and add at least one question.'**
  String get pleaseCompleteAllFields;

  /// No description provided for @questionText.
  ///
  /// In en, this message translates to:
  /// **'Question Text'**
  String get questionText;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @questionType.
  ///
  /// In en, this message translates to:
  /// **'Question Type'**
  String get questionType;

  /// No description provided for @textAnswer.
  ///
  /// In en, this message translates to:
  /// **'Text Answer'**
  String get textAnswer;

  /// No description provided for @trueFalse.
  ///
  /// In en, this message translates to:
  /// **'True / False'**
  String get trueFalse;

  /// No description provided for @multipleChoice.
  ///
  /// In en, this message translates to:
  /// **'Multiple Choice'**
  String get multipleChoice;

  /// No description provided for @answerTrue.
  ///
  /// In en, this message translates to:
  /// **'True'**
  String get answerTrue;

  /// No description provided for @answerFalse.
  ///
  /// In en, this message translates to:
  /// **'False'**
  String get answerFalse;

  /// No description provided for @option.
  ///
  /// In en, this message translates to:
  /// **'Option {number}'**
  String option(Object number);

  /// No description provided for @addOption.
  ///
  /// In en, this message translates to:
  /// **'Add Option'**
  String get addOption;

  /// No description provided for @step1_examDetails.
  ///
  /// In en, this message translates to:
  /// **'Exam Details'**
  String get step1_examDetails;

  /// No description provided for @step2_addQuestions.
  ///
  /// In en, this message translates to:
  /// **'Add Questions'**
  String get step2_addQuestions;

  /// No description provided for @step3_review.
  ///
  /// In en, this message translates to:
  /// **'Review & Submit'**
  String get step3_review;

  /// No description provided for @continue_.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @examSubmissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Submissions - {title}'**
  String examSubmissionsTitle(Object title);

  /// No description provided for @noSubmissionsYet.
  ///
  /// In en, this message translates to:
  /// **'No submissions yet.'**
  String get noSubmissionsYet;

  /// No description provided for @gradeValue.
  ///
  /// In en, this message translates to:
  /// **'Grade: {grade}'**
  String gradeValue(Object grade);

  /// No description provided for @notGraded.
  ///
  /// In en, this message translates to:
  /// **'Grade: Not Graded'**
  String get notGraded;

  /// No description provided for @studentAnswer.
  ///
  /// In en, this message translates to:
  /// **'Student\'s Answer'**
  String get studentAnswer;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct Answer'**
  String get correctAnswer;

  /// No description provided for @pointsAwarded.
  ///
  /// In en, this message translates to:
  /// **'Points Awarded'**
  String get pointsAwarded;

  /// No description provided for @questionNumber.
  ///
  /// In en, this message translates to:
  /// **'Question {number}'**
  String questionNumber(Object number);

  /// No description provided for @totalGrade.
  ///
  /// In en, this message translates to:
  /// **'Total Grade'**
  String get totalGrade;

  /// No description provided for @calculateAndSave.
  ///
  /// In en, this message translates to:
  /// **'Calculate & Save Grade'**
  String get calculateAndSave;

  /// No description provided for @gradeStudentTitle.
  ///
  /// In en, this message translates to:
  /// **'Grade: {studentName}'**
  String gradeStudentTitle(Object studentName);

  /// No description provided for @studentId.
  ///
  /// In en, this message translates to:
  /// **'Student ID: {id}'**
  String studentId(Object id);

  /// No description provided for @invalidGrade.
  ///
  /// In en, this message translates to:
  /// **'Invalid grade. Please enter a number.'**
  String get invalidGrade;

  /// No description provided for @gradeSaved.
  ///
  /// In en, this message translates to:
  /// **'Grade saved successfully!'**
  String get gradeSaved;

  /// No description provided for @saveGrade.
  ///
  /// In en, this message translates to:
  /// **'Save Grade'**
  String get saveGrade;

  /// No description provided for @addNewCourse.
  ///
  /// In en, this message translates to:
  /// **'Add New Course'**
  String get addNewCourse;

  /// No description provided for @courseTitle.
  ///
  /// In en, this message translates to:
  /// **'Course Title'**
  String get courseTitle;

  /// No description provided for @courseTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Algebra 101'**
  String get courseTitleHint;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @iconHint.
  ///
  /// In en, this message translates to:
  /// **'Enter an emoji, e.g., 📚'**
  String get iconHint;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @addCourse.
  ///
  /// In en, this message translates to:
  /// **'Add Course'**
  String get addCourse;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @courseAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Course \'{title}\' added successfully!'**
  String courseAddedSuccess(Object title);

  /// No description provided for @courseAddedError.
  ///
  /// In en, this message translates to:
  /// **'Failed to add course: {error}'**
  String courseAddedError(Object error);

  /// No description provided for @teacherDataNotFound.
  ///
  /// In en, this message translates to:
  /// **'Error: Could not find teacher data.'**
  String get teacherDataNotFound;

  /// No description provided for @myCourses.
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get myCourses;

  /// No description provided for @noCoursesAdded.
  ///
  /// In en, this message translates to:
  /// **'No courses have been added yet.'**
  String get noCoursesAdded;

  /// No description provided for @errorLoadingCourses.
  ///
  /// In en, this message translates to:
  /// **'Error loading courses: {error}'**
  String errorLoadingCourses(Object error);

  /// No description provided for @upcomingAssignments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Assignments'**
  String get upcomingAssignments;

  /// No description provided for @noUpcomingAssignments.
  ///
  /// In en, this message translates to:
  /// **'No upcoming assignments.'**
  String get noUpcomingAssignments;

  /// No description provided for @todaysSummary.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Summary'**
  String get todaysSummary;

  /// No description provided for @pendingAssignments.
  ///
  /// In en, this message translates to:
  /// **'Pending Assignments'**
  String get pendingAssignments;

  /// No description provided for @scheduledExams.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Exams'**
  String get scheduledExams;

  /// No description provided for @noExamsScheduled.
  ///
  /// In en, this message translates to:
  /// **'No exams scheduled.'**
  String get noExamsScheduled;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @keyMetrics.
  ///
  /// In en, this message translates to:
  /// **'Key Metrics'**
  String get keyMetrics;

  /// No description provided for @totalStudents.
  ///
  /// In en, this message translates to:
  /// **'Total Students'**
  String get totalStudents;

  /// No description provided for @totalCourses.
  ///
  /// In en, this message translates to:
  /// **'Total Courses'**
  String get totalCourses;

  /// No description provided for @assignmentsGraded.
  ///
  /// In en, this message translates to:
  /// **'Assignments Graded'**
  String get assignmentsGraded;

  /// No description provided for @examsHeld.
  ///
  /// In en, this message translates to:
  /// **'Exams Held'**
  String get examsHeld;

  /// No description provided for @performanceInsights.
  ///
  /// In en, this message translates to:
  /// **'Performance Insights'**
  String get performanceInsights;

  /// No description provided for @assignmentSubmissions.
  ///
  /// In en, this message translates to:
  /// **'Assignment Submissions'**
  String get assignmentSubmissions;

  /// No description provided for @assignmentSubmissionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Overview of submissions across all courses.'**
  String get assignmentSubmissionsSubtitle;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
