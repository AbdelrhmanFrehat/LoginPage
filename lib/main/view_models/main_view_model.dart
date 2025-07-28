import '../models/main_section.model.dart';

class MainViewModel {
  List<MainSection> get mainSections => [
    MainSection(
      type: MainSectionType.courses,
      title: 'الكورسات',
      icon: 'assets/icons/courses.png',
    ),
    MainSection(
      type: MainSectionType.addHomework,
      title: 'إضافة واجب',
      icon: 'assets/icons/homework.png',
    ),
    MainSection(
      type: MainSectionType.addExam,
      title: 'إضافة امتحان',
      icon: 'assets/icons/exam.png',
    ),
  ];
}
