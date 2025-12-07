import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../core/constants.dart';

class FirebaseService {
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;

  FirebaseService() {
    try {
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
    } catch (e) {
      debugPrint('Firebase services not available: $e');
    }
  }

  // Auth methods
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    if (_auth == null) throw Exception('Firebase Auth not available');
    return _auth!.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    if (_auth == null) throw Exception('Firebase Auth not available');
    return _auth!.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    if (_auth == null) throw Exception('Firebase Auth not available');
    return _auth!.signOut();
  }

  User? get currentUser => _auth?.currentUser;

  Stream<User?> get authStateChanges => _auth?.authStateChanges() ?? Stream.value(null);

  // User methods
  Future<void> createUserProfile(String uid, Map<String, dynamic> userData) async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    return _firestore!.collection(AppConstants.usersCollection).doc(uid).set(userData);
  }

  Future<DocumentSnapshot> getUserProfile(String uid) async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    return _firestore!.collection(AppConstants.usersCollection).doc(uid).get();
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> updates) async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    return _firestore!.collection(AppConstants.usersCollection).doc(uid).update(updates);
  }

  Stream<DocumentSnapshot> getUserProfileStream(String uid) {
    if (_firestore == null) return Stream.value(null as DocumentSnapshot);
    return _firestore!.collection(AppConstants.usersCollection).doc(uid).snapshots();
  }

  // Hackathon methods
  Future<QuerySnapshot> getHackathons() async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    return _firestore!
        .collection(AppConstants.hackathonsCollection)
        .orderBy('startDate', descending: false)
        .get();
  }

  Stream<QuerySnapshot> getHackathonsStream() {
    if (_firestore == null) return Stream.value(null as QuerySnapshot);
    return _firestore!
        .collection(AppConstants.hackathonsCollection)
        .orderBy('startDate', descending: false)
        .snapshots();
  }

  Future<DocumentSnapshot> getHackathon(String hackathonId) async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    return _firestore!.collection(AppConstants.hackathonsCollection).doc(hackathonId).get();
  }

  Stream<DocumentSnapshot> getHackathonStream(String hackathonId) {
    if (_firestore == null) return Stream.value(null as DocumentSnapshot);
    return _firestore!.collection(AppConstants.hackathonsCollection).doc(hackathonId).snapshots();
  }

  Future<void> createHackathon(Map<String, dynamic> hackathonData) async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    await _firestore!.collection(AppConstants.hackathonsCollection).add(hackathonData);
  }

  Future<void> updateHackathon(String hackathonId, Map<String, dynamic> updates) async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    return _firestore!.collection(AppConstants.hackathonsCollection).doc(hackathonId).update(updates);
  }

  // Team methods
  Future<QuerySnapshot> getTeamsForHackathon(String hackathonId) async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    return _firestore!
        .collection(AppConstants.teamsCollection)
        .where('hackathonId', isEqualTo: hackathonId)
        .get();
  }

  Future<void> createTeam(Map<String, dynamic> teamData) async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    await _firestore!.collection(AppConstants.teamsCollection).add(teamData);
  }

  Future<void> joinTeam(String teamId, String userId) async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    return _firestore!.collection(AppConstants.teamsCollection).doc(teamId).update({
      'members': FieldValue.arrayUnion([userId]),
    });
  }

  // Team Request methods
  Future<QuerySnapshot> getTeamRequests(String userId) async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    return _firestore!
        .collection(AppConstants.teamRequestsCollection)
        .where('requesterId', isEqualTo: userId)
        .get();
  }

  Future<void> createTeamRequest(Map<String, dynamic> requestData) async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    await _firestore!.collection(AppConstants.teamRequestsCollection).add(requestData);
  }

  Future<void> updateTeamRequest(String requestId, Map<String, dynamic> updates) async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    return _firestore!.collection(AppConstants.teamRequestsCollection).doc(requestId).update(updates);
  }

  // Skills methods
  Future<QuerySnapshot> getSkills() async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    return _firestore!.collection(AppConstants.skillsCollection).get();
  }

  Future<void> addSkillToUser(String userId, String skill) async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    return _firestore!.collection(AppConstants.usersCollection).doc(userId).update({
      'skills': FieldValue.arrayUnion([skill]),
    });
  }

  Future<void> removeSkillFromUser(String userId, String skill) async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    return _firestore!.collection(AppConstants.usersCollection).doc(userId).update({
      'skills': FieldValue.arrayRemove([skill]),
    });
  }

  // Search methods
  Future<QuerySnapshot> searchHackathons(String query) async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    return _firestore!
        .collection(AppConstants.hackathonsCollection)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThan: query + 'z')
        .get();
  }

  Future<QuerySnapshot> searchUsers(String query) async {
    if (_firestore == null) throw Exception('Firebase Firestore not available');
    return _firestore!
        .collection(AppConstants.usersCollection)
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + 'z')
        .get();
  }
}
