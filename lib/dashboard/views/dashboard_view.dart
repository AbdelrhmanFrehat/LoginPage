// lib/dashboard/views/dashboard_view.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_portal/auth/viewmodels/login_viewmodel.dart';
import 'package:teacher_portal/dashboard/Viewmodels/dashboard_viewmodel.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final teacher = context.read<AuthenticationViewModel>().teacher;

      if (teacher != null && teacher.id != null) {
        context.read<DashboardViewModel>().fetchDashboardData(teacher.id!);
      } else {
        print("DashboardView: Teacher data not available.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = Colors.blue;

    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Key Metrics", theme),
              const SizedBox(height: 16),
              _buildMetricsGrid(viewModel),
              const SizedBox(height: 24),
              _buildSectionHeader("Performance Insights", theme),
              const SizedBox(height: 16),
              _buildTimeRangeSelector(),
              const SizedBox(height: 16),
              _buildChartCard(
                title: "Assignment Submissions",
                subtitle:
                    "Overview of submitted assignments across all courses.",
                chart: _buildBarChart(
                  primaryColor,
                  viewModel.assignmentSubmissionsData,
                ),
                theme: theme,
              ),
              const SizedBox(height: 16),
              _buildChartCard(
                title: "Student Attendance",
                subtitle:
                    "Current attendance distribution for active students.",
                chart: _buildPieChart(),
                theme: theme,
              ),
              const SizedBox(height: 16),
              _buildChartCard(
                title: "Grading Trends",
                subtitle: "Average grade progression over the last few months.",
                chart: _buildLineChart(primaryColor),
                theme: theme,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMetricsGrid(DashboardViewModel viewModel) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMetricCard(
          icon: Icons.people_outline,
          value: viewModel.totalStudents.toString(), // <-- بيانات حقيقية
          label: "Total Students",
          color: Colors.blue,
        ),
        _buildMetricCard(
          icon: Icons.library_books_outlined,
          value: viewModel.totalCourses.toString(), // <-- بيانات حقيقية
          label: "Total Courses",
          color: Colors.blue,
        ),
        _buildMetricCard(
          icon: Icons.assignment_turned_in_outlined,
          value: viewModel.assignmentsGraded.toString(), // <-- بيانات حقيقية
          label: "Assignments Graded",
          color: Colors.blue,
        ),
        _buildMetricCard(
          icon: Icons.emoji_events_outlined,
          value: viewModel.examsHeld.toString(), // <-- بيانات حقيقية
          label: "Exams Held",
          color: Colors.blue,
        ),
      ],
    );
  }

  // ... (بقية الدوال المساعدة كما هي بدون تغيير في التوقيع)
  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Row(
      children: [
        OutlinedButton(onPressed: () {}, child: const Text("Weekly")),
        const SizedBox(width: 8),
        ElevatedButton(onPressed: () {}, child: const Text("Monthly")),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.calendar_today_outlined, size: 16),
          label: const Text("Custom"),
        ),
      ],
    );
  }

  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required Widget chart,
    required ThemeData theme,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(height: 200, child: chart),
          ],
        ),
      ),
    );
  }

  // رسم بياني للأعمدة (Assignment Submissions)
  Widget _buildBarChart(Color primaryColor, Map<String, double> data) {
    final barGroups = data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final courseData = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: courseData.value,
            color: primaryColor,
            width: 22,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        // maxY: 100, // يمكن جعله ديناميكياً
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < data.keys.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 4.0,
                    child: Text(
                      data.keys.elementAt(value.toInt()),
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
      ),
    );
  }

  // ... (بقية الرسوم البيانية تبقى ببيانات ثابتة حالياً)
  Widget _buildPieChart() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(enabled: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  color: Colors.blue,
                  value: 85,
                  title: '85%',
                  radius: 50,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PieChartSectionData(
                  color: Colors.red,
                  value: 10,
                  title: '10%',
                  radius: 50,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PieChartSectionData(
                  color: Colors.black,
                  value: 5,
                  title: '5%',
                  radius: 50,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLegendItem(Colors.blue, "Present (85%)"),
              const SizedBox(height: 4),
              _buildLegendItem(Colors.red, "Absent (10%)"),
              const SizedBox(height: 4),
              _buildLegendItem(Colors.black, "Late (5%)"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  Widget _buildLineChart(Color primaryColor) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                String text = '';
                switch (value.toInt()) {
                  case 0:
                    text = 'Jan';
                    break;
                  case 1:
                    text = 'Feb';
                    break;
                  case 2:
                    text = 'Mar';
                    break;
                  case 3:
                    text = 'Apr';
                    break;
                  case 4:
                    text = 'May';
                    break;
                }
                return Text(
                  text,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                if (value == 0 ||
                    value == 25 ||
                    value == 50 ||
                    value == 75 ||
                    value == 100) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 4,
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 78),
              FlSpot(1, 82),
              FlSpot(2, 81),
              FlSpot(3, 85),
              FlSpot(4, 84),
            ],
            isCurved: true,
            color: primaryColor,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: primaryColor.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
