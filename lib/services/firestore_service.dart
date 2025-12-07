import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/activity_log_model.dart';
import '../models/challenge_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User Profile Methods
  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
    required String city,
    required String commuteMode,
  }) async {
    final user = UserModel(
      uid: uid,
      name: name,
      email: email,
      city: city,
      commuteMode: commuteMode,
    );

    await _firestore.collection('users').doc(uid).set(user.toJson());
  }

  Stream<UserModel?> getUserProfile(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromJson(doc.data()!);
    });
  }

  Future<UserModel?> getUserProfileOnce(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data()!);
  }

  // Activity Log Methods
  Future<void> createActivityLog({
    required String userId,
    required String category,
    required int co2Grams,
    Map<String, dynamic>? details,
    String? notes,
    String? photoUrl,
  }) async {
    final logId = _firestore.collection('logs').doc().id;
    
    final log = ActivityLogModel(
      logId: logId,
      userId: userId,
      timestamp: DateTime.now(),
      category: category,
      co2Grams: co2Grams,
      details: details ?? {},
      notes: notes ?? '',
      photoUrl: photoUrl,
    );

    // Create log
    await _firestore.collection('logs').doc(logId).set(log.toJson());

    // Update user stats atomically
    await _firestore.runTransaction((transaction) async {
      final userRef = _firestore.collection('users').doc(userId);
      final userDoc = await transaction.get(userRef);

      if (userDoc.exists) {
        final currentCO2 = userDoc.data()?['totalCO2Saved'] ?? 0;
        final currentPoints = userDoc.data()?['points'] ?? 0;
        
        transaction.update(userRef, {
          'totalCO2Saved': currentCO2 + co2Grams,
          'points': currentPoints + (co2Grams ~/ 10), // 1 point per 10g CO2
          'lastActivityAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  Stream<List<ActivityLogModel>> getUserLogs(String userId, {int limit = 50}) {
    return _firestore
        .collection('logs')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ActivityLogModel.fromJson(doc.data()))
          .toList();
    });
  }

  // Challenge Methods
  Stream<List<ChallengeModel>> getChallenges() {
    return _firestore
        .collection('challenges')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChallengeModel.fromJson(doc.data()))
          .toList();
    });
  }

  Future<void> recordChallengeCompletion({
    required String userId,
    required String challengeId,
    required int pointsAwarded,
  }) async {
    final completionId = _firestore.collection('challenge_completions').doc().id;
    final now = DateTime.now();
    final dateKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final completion = ChallengeCompletionModel(
      completionId: completionId,
      userId: userId,
      challengeId: challengeId,
      completedAt: now,
      dateKey: dateKey,
      pointsAwarded: pointsAwarded,
    );

    // Record completion
    await _firestore
        .collection('challenge_completions')
        .doc(completionId)
        .set(completion.toJson());

    // Update user points
    await _firestore.runTransaction((transaction) async {
      final userRef = _firestore.collection('users').doc(userId);
      final userDoc = await transaction.get(userRef);

      if (userDoc.exists) {
        final currentPoints = userDoc.data()?['points'] ?? 0;
        transaction.update(userRef, {
          'points': currentPoints + pointsAwarded,
        });
      }
    });
  }

  Stream<Map<String, int>> getTodayChallengeCompletions(String userId) {
    final now = DateTime.now();
    final dateKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    return _firestore
        .collection('challenge_completions')
        .where('userId', isEqualTo: userId)
        .where('dateKey', isEqualTo: dateKey)
        .snapshots()
        .map((snapshot) {
      final completions = <String, int>{};
      for (final doc in snapshot.docs) {
        final challengeId = doc.data()['challengeId'] as String;
        completions[challengeId] = (completions[challengeId] ?? 0) + 1;
      }
      return completions;
    });
  }

  // Leaderboard Methods
  Stream<List<UserModel>> getCityLeaderboard(String city, {int limit = 100}) {
    return _firestore
        .collection('users')
        .where('city', isEqualTo: city)
        .orderBy('points', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    });
  }

  Stream<List<UserModel>> getGlobalLeaderboard({int limit = 100}) {
    return _firestore
        .collection('users')
        .orderBy('points', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    });
  }

  // Friend Methods
  Future<void> addFriendByEmail(String userId, String friendEmail) async {
    final friendQuery = await _firestore
        .collection('users')
        .where('email', isEqualTo: friendEmail)
        .limit(1)
        .get();

    if (friendQuery.docs.isEmpty) {
      throw Exception('User not found');
    }

    final friendId = friendQuery.docs.first.id;

    if (friendId == userId) {
      throw Exception('Cannot add yourself as friend');
    }

    final friendshipId = _firestore.collection('friendships').doc().id;

    await _firestore.collection('friendships').doc(friendshipId).set({
      'friendshipId': friendshipId,
      'userId1': userId,
      'userId2': friendId,
      'status': 'accepted',
      'requestedBy': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update friendIds in both user profiles
    await _firestore.collection('users').doc(userId).update({
      'friendIds': FieldValue.arrayUnion([friendId]),
    });

    await _firestore.collection('users').doc(friendId).update({
      'friendIds': FieldValue.arrayUnion([userId]),
    });
  }

  Stream<List<UserModel>> getFriends(String userId) async* {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final friendIds = List<String>.from(userDoc.data()?['friendIds'] ?? []);

    if (friendIds.isEmpty) {
      yield [];
      return;
    }

    yield* _firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: friendIds)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    });
  }
}
