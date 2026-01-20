import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/activity_log_model.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/activity_log_item.dart';

class TrackerHistoryScreen extends StatefulWidget {
  const TrackerHistoryScreen({super.key});

  @override
  State<TrackerHistoryScreen> createState() => _TrackerHistoryScreenState();
}

class _TrackerHistoryScreenState extends State<TrackerHistoryScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  int _selectedIndex = 1;

  void _onNavItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        // Already on tracker
        break;
      case 2:
        Navigator.pushNamed(context, '/ar-challenges');
        break;
      case 3:
        Navigator.pushNamed(context, '/social');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => _exportData(context),
            tooltip: 'Export Data',
          ),
        ],
      ),
      body: StreamBuilder<List<ActivityLogModel>>(
        stream: _firestoreService.getUserLogs(user.uid, limit: 50),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final logs = snapshot.data ?? [];
          final weeklyData = _calculateWeeklyData(logs);
          final categoryData = _calculateCategoryData(logs);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Weekly Bar Chart
                const Text(
                  'This Week',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: weeklyData.isEmpty
                              ? 1000
                              : weeklyData.map((e) => e.co2).reduce((a, b) => a > b ? a : b) * 1.2,
                          barGroups: weeklyData.asMap().entries.map((entry) {
                            return BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.co2.toDouble(),
                                  color: const Color(0xFF4CAF50),
                                  width: 20,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            );
                          }).toList(),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}g',
                                    style: const TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                  return Text(
                                    days[value.toInt() % 7],
                                    style: const TextStyle(fontSize: 12),
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: FlGridData(show: true),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Category Pie Chart
                const Text(
                  'By Category',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 150,
                            child: PieChart(
                              PieChartData(
                                sections: categoryData.entries.map((entry) {
                                  final color = _getCategoryColor(entry.key);
                                  final total = categoryData.values.fold(0, (a, b) => a + b);
                                  final percent = (entry.value / total * 100).toStringAsFixed(0);
                                  return PieChartSectionData(
                                    value: entry.value.toDouble(),
                                    title: '$percent%',
                                    color: color,
                                    radius: 50,
                                    titleStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                }).toList(),
                                sectionsSpace: 2,
                                centerSpaceRadius: 0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: categoryData.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(entry.key),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${entry.key}: ${entry.value}g',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Recent Activity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${logs.length} logs',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (logs.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(
                        child: Text(
                          'No activity logs yet.\nStart logging your activities!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                else
                  ...logs.take(10).map((log) => ActivityLogItem(log: log)),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onNavItemTapped,
      ),
    );
  }

  List<DailyData> _calculateWeeklyData(List<ActivityLogModel> logs) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    final dailyData = List.generate(7, (index) {
      final date = weekStart.add(Duration(days: index));
      final dayLogs = logs.where((log) {
        return log.timestamp.year == date.year &&
               log.timestamp.month == date.month &&
               log.timestamp.day == date.day;
      });

      final totalCO2 = dayLogs.fold(0, (sum, log) => sum + log.co2Grams);
      return DailyData(date: date, co2: totalCO2);
    });

    return dailyData;
  }

  Map<String, int> _calculateCategoryData(List<ActivityLogModel> logs) {
    final categoryTotals = <String, int>{
      'Food': 0,
      'Transport': 0,
      'Energy': 0,
    };

    for (final log in logs) {
      final category = log.category.substring(0, 1).toUpperCase() +
                      log.category.substring(1).toLowerCase();
      categoryTotals[category] = (categoryTotals[category] ?? 0) + log.co2Grams;
    }

    return categoryTotals;
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'transport':
        return const Color(0xFF4CAF50);
      case 'energy':
        return const Color(0xFF2196F3);
      default:
        return Colors.grey;
    }
  }

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class DailyData {
  final DateTime date;
  final int co2;

  DailyData({required this.date, required this.co2});
}
