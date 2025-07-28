enum MainSectionType { courses, addHomework, addExam }

class MainSection {
  final MainSectionType type;
  final String title;
  final String icon;

  MainSection({required this.type, required this.title, required this.icon});
}
