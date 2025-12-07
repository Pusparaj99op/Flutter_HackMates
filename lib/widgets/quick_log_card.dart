import 'package:flutter/material.dart';

class QuickLogCard extends StatelessWidget {
  final String category;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const QuickLogCard({
    super.key,
    required this.category,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 32,
                color: _getCategoryColor(),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor() {
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
}
