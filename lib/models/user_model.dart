import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String city;
  final String commuteMode;
  final int totalCO2Saved;
  final int points;
  final int currentStreak;
  final int weeklyTarget;
  final List<String> badges;
  final List<String> friendIds;
  final DateTime createdAt;
  final DateTime lastActivityAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.city,
    required this.commuteMode,
    this.totalCO2Saved = 0,
    this.points = 0,
    this.currentStreak = 0,
    this.weeklyTarget = 7000,
    this.badges = const [],
    this.friendIds = const [],
    DateTime? createdAt,
    DateTime? lastActivityAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastActivityAt = lastActivityAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'city': city,
      'commuteMode': commuteMode,
      'totalCO2Saved': totalCO2Saved,
      'points': points,
      'currentStreak': currentStreak,
      'weeklyTarget': weeklyTarget,
      'badges': badges,
      'friendIds': friendIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActivityAt': Timestamp.fromDate(lastActivityAt),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      city: json['city'] as String,
      commuteMode: json['commuteMode'] as String,
      totalCO2Saved: json['totalCO2Saved'] as int? ?? 0,
      points: json['points'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      weeklyTarget: json['weeklyTarget'] as int? ?? 7000,
      badges: List<String>.from(json['badges'] ?? []),
      friendIds: List<String>.from(json['friendIds'] ?? []),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActivityAt: (json['lastActivityAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  UserModel copyWith({
    String? name,
    String? city,
    String? commuteMode,
    int? totalCO2Saved,
    int? points,
    int? currentStreak,
    int? weeklyTarget,
    List<String>? badges,
    List<String>? friendIds,
    DateTime? lastActivityAt,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email,
      city: city ?? this.city,
      commuteMode: commuteMode ?? this.commuteMode,
      totalCO2Saved: totalCO2Saved ?? this.totalCO2Saved,
      points: points ?? this.points,
      currentStreak: currentStreak ?? this.currentStreak,
      weeklyTarget: weeklyTarget ?? this.weeklyTarget,
      badges: badges ?? this.badges,
      friendIds: friendIds ?? this.friendIds,
      createdAt: createdAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
    );
  }
}
