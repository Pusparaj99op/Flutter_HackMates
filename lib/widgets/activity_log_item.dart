import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity_log_model.dart';

class ActivityLogItem extends StatelessWidget {
  final ActivityLogModel log;

  const ActivityLogItem({
    super.key,
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor().withOpacity(0.2),
          child: Icon(
            _getCategoryIcon(),
            color: _getCategoryColor(),
          ),
        ),
        title: Text(
          '${_capitalize(log.category)} - ${log.co2Grams}g CO₂',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          DateFormat('MMM dd, yyyy • hh:mm a').format(log.timestamp),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  IconData _getCategoryIcon() {
    switch (log.category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'energy':
        return Icons.bolt;
      default:
        return Icons.eco;
    }
  }

  Color _getCategoryColor() {
    switch (log.category.toLowerCase()) {
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

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
