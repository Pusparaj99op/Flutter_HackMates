import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityLogModel {
  final String logId;
  final String userId;
  final DateTime timestamp;
  final String category; // food, transport, energy
  final int co2Grams;
  final Map<String, dynamic> details;
  final String notes;
  final String? photoUrl;

  ActivityLogModel({
    required this.logId,
    required this.userId,
    required this.timestamp,
    required this.category,
    required this.co2Grams,
    this.details = const {},
    this.notes = '',
    this.photoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'logId': logId,
      'userId': userId,
      'timestamp': Timestamp.fromDate(timestamp),
      'category': category,
      'co2Grams': co2Grams,
      'details': details,
      'notes': notes,
      'photoUrl': photoUrl,
    };
  }

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      logId: json['logId'] as String,
      userId: json['userId'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      category: json['category'] as String,
      co2Grams: json['co2Grams'] as int,
      details: Map<String, dynamic>.from(json['details'] ?? {}),
      notes: json['notes'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
    );
  }

  // CO2 Calculation Methods
  static int calculateFoodCO2({
    required String mealType,
    required int servings,
  }) {
    final emissions = {
      'Beef': 3000,
      'Chicken': 800,
      'Fish': 600,
      'Vegetarian': 500,
      'Vegan': 300,
    };
    return (emissions[mealType] ?? 500) * servings;
  }

  static int calculateTransportCO2({
    required String mode,
    required double distanceKm,
  }) {
    final emissions = {
      'Car': 120,
      'Bus': 40,
      'Bike': 0,
      'Walk': 0,
    };
    return ((emissions[mode] ?? 0) * distanceKm).round();
  }

  static int calculateEnergyCO2({
    required String source,
    required double usageKwh,
  }) {
    final emissions = {
      'Electricity': 500,
      'Gas': 200,
    };
    return ((emissions[source] ?? 0) * usageKwh).round();
  }
}
