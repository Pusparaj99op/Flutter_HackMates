import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/firebase_service.dart';

enum AuthState { initial, authenticated, unauthenticated }

class AuthProvider with ChangeNotifier {
  late final FirebaseService _firebaseService;

  AuthState _authState = AuthState.unauthenticated; // Start as unauthenticated
  User? _user;
  Map<String, dynamic>? _userProfile;

  AuthState get authState => _authState;
  User? get user => _user;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isAuthenticated => _authState == AuthState.authenticated;

  AuthProvider() {
    try {
      _firebaseService = FirebaseService();
      _init();
    } catch (e) {
      debugPrint('AuthProvider initialization failed: $e');
      _authState = AuthState.unauthenticated;
      notifyListeners();
    }
  }

  void _init() {
    try {
      _firebaseService.authStateChanges.listen((User? user) {
        _user = user;
        if (user != null) {
          _authState = AuthState.authenticated;
          _loadUserProfile();
        } else {
          _authState = AuthState.unauthenticated;
          _userProfile = null;
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Firebase auth initialization failed: $e');
      _authState = AuthState.unauthenticated;
      notifyListeners();
    }
  }

  Future<void> _loadUserProfile() async {
    if (_user == null) return;

    try {
      final doc = await _firebaseService.getUserProfile(_user!.uid);
      if (doc.exists) {
        _userProfile = doc.data() as Map<String, dynamic>;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      await _firebaseService.signInWithEmailAndPassword(email, password);
      return true;
    } catch (e) {
      debugPrint('Sign in error: $e');
      return false;
    }
  }

  Future<bool> signUp(String email, String password, Map<String, dynamic> userData) async {
    try {
      final credential = await _firebaseService.createUserWithEmailAndPassword(email, password);
      await _firebaseService.createUserProfile(credential.user!.uid, userData);
      return true;
    } catch (e) {
      debugPrint('Sign up error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    if (_user == null) return false;

    try {
      await _firebaseService.updateUserProfile(_user!.uid, updates);
      _userProfile = {...?_userProfile, ...updates};
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Update profile error: $e');
      return false;
    }
  }

  Future<bool> addSkill(String skill) async {
    if (_user == null) return false;

    try {
      await _firebaseService.addSkillToUser(_user!.uid, skill);
      final skills = List<String>.from(_userProfile?['skills'] ?? []);
      skills.add(skill);
      _userProfile = {...?_userProfile, 'skills': skills};
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Add skill error: $e');
      return false;
    }
  }

  Future<bool> removeSkill(String skill) async {
    if (_user == null) return false;

    try {
      await _firebaseService.removeSkillFromUser(_user!.uid, skill);
      final skills = List<String>.from(_userProfile?['skills'] ?? []);
      skills.remove(skill);
      _userProfile = {...?_userProfile, 'skills': skills};
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Remove skill error: $e');
      return false;
    }
  }
}
