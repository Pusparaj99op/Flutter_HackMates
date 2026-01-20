import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeModel {
  final String challengeId;
  final String title;
  final String description;
  final String arType; // scan, place, gps
  final int pointValue;
  final int dailyLimit;
  final String icon;
  final String difficulty;

  ChallengeModel({
    required this.challengeId,
    required this.title,
    required this.description,
    required this.arType,
    required this.pointValue,
    this.dailyLimit = 1,
    this.icon = 'default',
    this.difficulty = 'medium',
  });

  Map<String, dynamic> toJson() {
    return {
      'challengeId': challengeId,
      'title': title,
      'description': description,
      'arType': arType,
      'pointValue': pointValue,
      'dailyLimit': dailyLimit,
      'icon': icon,
      'difficulty': difficulty,
    };
  }

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      challengeId: json['challengeId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      arType: json['arType'] as String,
      pointValue: json['pointValue'] as int,
      dailyLimit: json['dailyLimit'] as int? ?? 1,
      icon: json['icon'] as String? ?? 'default',
      difficulty: json['difficulty'] as String? ?? 'medium',
    );
  }
}

class ChallengeCompletionModel {
  final String completionId;
  final String userId;
  final String challengeId;
  final DateTime completedAt;
  final String dateKey;
  final int pointsAwarded;

  ChallengeCompletionModel({
    required this.completionId,
    required this.userId,
    required this.challengeId,
    required this.completedAt,
    required this.dateKey,
    required this.pointsAwarded,
  });

  Map<String, dynamic> toJson() {
    return {
      'completionId': completionId,
      'userId': userId,
      'challengeId': challengeId,
      'completedAt': Timestamp.fromDate(completedAt),
      'dateKey': dateKey,
      'pointsAwarded': pointsAwarded,
    };
  }

  factory ChallengeCompletionModel.fromJson(Map<String, dynamic> json) {
    return ChallengeCompletionModel(
      completionId: json['completionId'] as String,
      userId: json['userId'] as String,
      challengeId: json['challengeId'] as String,
      completedAt: (json['completedAt'] as Timestamp).toDate(),
      dateKey: json['dateKey'] as String,
      pointsAwarded: json['pointsAwarded'] as int,
    );
  }
}
