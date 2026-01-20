import 'package:flutter/material.dart';

class LeaderboardItem extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final int totalCO2;
  final bool showRankBadge;

  const LeaderboardItem({
    super.key,
    required this.rank,
    required this.name,
    required this.points,
    required this.totalCO2,
    this.showRankBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _buildRankBadge(),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${totalCO2}g CO₂ saved',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$points',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4CAF50),
              ),
            ),
            const Text(
              'points',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankBadge() {
    if (!showRankBadge || rank > 3) {
      return CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Text(
          '#$rank',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    Color badgeColor;
    String emoji;

    switch (rank) {
      case 1:
        badgeColor = const Color(0xFFFFD700); // Gold
        emoji = '🥇';
        break;
      case 2:
        badgeColor = const Color(0xFFC0C0C0); // Silver
        emoji = '🥈';
        break;
      case 3:
        badgeColor = const Color(0xFFCD7F32); // Bronze
        emoji = '🥉';
        break;
      default:
        badgeColor = Colors.grey;
        emoji = '';
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          backgroundColor: badgeColor,
          radius: 20,
        ),
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
      ],
    );
  }
}
