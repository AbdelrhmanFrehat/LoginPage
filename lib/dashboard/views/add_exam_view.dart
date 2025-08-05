import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_portal/database/models/exam_question_model.dart';
import 'package:teacher_portal/dashboard/viewmodels/add_exam_viewmodel.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/generated/app_localizations.dart';

class AddExamView extends StatelessWidget {
  final String courseId;
  const AddExamView({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddExamViewModel(courseId: courseId),
      child: Consumer<AddExamViewModel>(
        builder: (context, viewModel, child) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            appBar: AppBar(title: Text(l10n.addExam)),
            body: Stepper(
              type: StepperType.vertical,
              currentStep: viewModel.currentStep,
              onStepTapped: viewModel.onStepTapped,
              onStepContinue: viewModel.onStepContinue,
              onStepCancel: viewModel.onStepCancel,
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: [
                      if (viewModel.currentStep == 2)
                        ElevatedButton.icon(
                          icon: viewModel.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.check_circle),
                          label: Text(l10n.submitExam),
                          onPressed: viewModel.isLoading
                              ? null
                              : () async {
                                  final success = await viewModel.submitExam();
                                  if (!context.mounted) return;
                                  if (success) {
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          l10n.pleaseCompleteAllFields,
                                        ),
                                      ),
                                    );
                                  }
                                },
                        )
                      else
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text(l10n.continue_),
                        ),
                      if (viewModel.currentStep > 0)
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: Text(l10n.back),
                        ),
                    ],
                  ),
                );
              },
              steps: [
                _buildStep1(viewModel, l10n),
                _buildStep2(context, viewModel, l10n),
                _buildStep3(context, viewModel, l10n),
              ],
            ),
          );
        },
      ),
    );
  }

  Step _buildStep1(AddExamViewModel viewModel, AppLocalizations l10n) {
    return Step(
      title: Text(l10n.step1_examDetails),
      isActive: viewModel.currentStep >= 0,
      state: viewModel.currentStep > 0 ? StepState.complete : StepState.indexed,
      content: Form(
        key: viewModel.formKeyStep1,
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                TextFormField(
                  controller: viewModel.titleController,
                  decoration: InputDecoration(
                    labelText: l10n.examTitle,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                _buildDateTimePicker(
                  context: context,
                  label: l10n.pickDate,
                  value: viewModel.selectedDate != null
                      ? DateFormat.yMd().format(viewModel.selectedDate!)
                      : null,
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: viewModel.selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) viewModel.setDate(date);
                  },
                ),
                _buildDateTimePicker(
                  context: context,
                  label: l10n.pickStartTime,
                  value: viewModel.startTime?.format(context),
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: viewModel.startTime ?? TimeOfDay.now(),
                    );
                    if (time != null) viewModel.setStartTime(time);
                  },
                ),
                _buildDateTimePicker(
                  context: context,
                  label: l10n.pickEndTime,
                  value: viewModel.endTime?.format(context),
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: viewModel.endTime ?? TimeOfDay.now(),
                    );
                    if (time != null) viewModel.setEndTime(time);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateTimePicker({
    required BuildContext context,
    required String label,
    required String? value,
    required Future<void> Function() onPressed,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(label),
        subtitle: Text(
          value ?? 'Not set',
          style: TextStyle(
            color: value != null
                ? Theme.of(context).textTheme.bodyLarge?.color
                : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.edit_calendar),
        onTap: onPressed,
      ),
    );
  }

  Step _buildStep2(
    BuildContext context,
    AddExamViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Step(
      title: Text(l10n.step2_addQuestions),
      isActive: viewModel.currentStep >= 1,
      state: viewModel.currentStep > 1 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          if (viewModel.questions.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "No questions added yet. Press 'Add Question' to begin.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ...viewModel.questions.asMap().entries.map((entry) {
            final index = entry.key;
            final q = entry.value;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: CircleAvatar(child: Text((index + 1).toString())),
                title: Text(
                  q.questionText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  "${q.type.replaceAll('_', ' ').toUpperCase()} - ${q.grade} pts",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => viewModel.removeQuestionAt(index),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _addQuestionDialog(context, viewModel, l10n),
            icon: const Icon(Icons.add),
            label: Text(l10n.addQuestion),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
            ),
          ),
        ],
      ),
    );
  }

  Step _buildStep3(
    BuildContext context,
    AddExamViewModel viewModel,
    AppLocalizations l10n,
  ) {
    return Step(
      title: Text(l10n.step3_review),
      isActive: viewModel.currentStep >= 2,
      content: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReviewItem(l10n.examTitle, viewModel.titleController.text),
              _buildReviewItem(
                l10n.pickDate,
                viewModel.selectedDate != null
                    ? DateFormat.yMd().format(viewModel.selectedDate!)
                    : 'N/A',
              ),
              // الـ context أصبح متاحًا هنا
              _buildReviewItem(
                l10n.pickStartTime,
                viewModel.startTime?.format(context) ?? 'N/A',
              ),
              _buildReviewItem(
                l10n.pickEndTime,
                viewModel.endTime?.format(context) ?? 'N/A',
              ),
              _buildReviewItem(
                l10n.questions,
                viewModel.questions.length.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Future<void> _addQuestionDialog(
    BuildContext context,
    AddExamViewModel viewModel,
    AppLocalizations l10n,
  ) async {
    final qText = TextEditingController();
    final qPoints = TextEditingController();
    String questionType = 'text';
    String? correctTrueFalse;
    int? correctIndex;
    final options = <TextEditingController>[
      TextEditingController(),
      TextEditingController(),
    ];

    final result = await showDialog<ExamQuestion>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: Text(l10n.addQuestion),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: qText,
                    decoration: InputDecoration(labelText: l10n.questionText),
                  ),
                  TextField(
                    controller: qPoints,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.points),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: questionType,
                    items: [
                      DropdownMenuItem(
                        value: 'text',
                        child: Text(l10n.textAnswer),
                      ),
                      DropdownMenuItem(
                        value: 'true_false',
                        child: Text(l10n.trueFalse),
                      ),
                      DropdownMenuItem(
                        value: 'multiple_choice',
                        child: Text(l10n.multipleChoice),
                      ),
                    ],
                    onChanged: (val) =>
                        setDialogState(() => questionType = val!),
                    decoration: InputDecoration(labelText: l10n.questionType),
                  ),
                  if (questionType == 'true_false')
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text(l10n.answerTrue),
                            value: "true",
                            groupValue: correctTrueFalse,
                            onChanged: (val) =>
                                setDialogState(() => correctTrueFalse = val),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: Text(l10n.answerFalse),
                            value: "false",
                            groupValue: correctTrueFalse,
                            onChanged: (val) =>
                                setDialogState(() => correctTrueFalse = val),
                          ),
                        ),
                      ],
                    ),
                  if (questionType == 'multiple_choice') ...[
                    ...options.asMap().entries.map((entry) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Radio<int>(
                          value: entry.key,
                          groupValue: correctIndex,
                          onChanged: (val) =>
                              setDialogState(() => correctIndex = val),
                        ),
                        title: TextField(
                          controller: entry.value,
                          decoration: InputDecoration(
                            labelText: l10n.option(entry.key + 1),
                          ),
                        ),
                      );
                    }),
                    TextButton.icon(
                      onPressed: () => setDialogState(
                        () => options.add(TextEditingController()),
                      ),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addOption),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  final points = int.tryParse(qPoints.text);
                  if (qText.text.isEmpty || points == null) return;
                  final base = {
                    'questionText': qText.text,
                    'grade': points,
                    'type': questionType,
                  };
                  if (questionType == 'true_false' &&
                      correctTrueFalse != null) {
                    base['correctAnswer'] = correctTrueFalse == 'true';
                  }
                  if (questionType == 'multiple_choice') {
                    final opts = options
                        .map((o) => o.text)
                        .where((t) => t.isNotEmpty)
                        .toList();
                    if (opts.length < 2 ||
                        correctIndex == null ||
                        correctIndex! >= opts.length)
                      return;
                    base['options'] = opts;
                    base['correctAnswer'] = opts[correctIndex!];
                  }
                  Navigator.pop(dialogContext, ExamQuestion.fromMap(base));
                },
                child: Text(l10n.add),
              ),
            ],
          );
        },
      ),
    );

    if (result != null) {
      viewModel.addQuestion(result);
    }
  }
}
