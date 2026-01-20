import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Email/Password Authentication
  Future<Map<String, dynamic>> signInWithEmailPassword(
    String email,
    String password, {
    bool isSignUp = false,
  }) async {
    try {
      UserCredential credential;

      if (isSignUp) {
        credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      final user = credential.user;
      if (user == null) {
        return {'success': false, 'error': 'Authentication failed'};
      }

      // Check if user profile exists
      final profileDoc = await _firestore.collection('users').doc(user.uid).get();
      final hasProfile = profileDoc.exists;

      notifyListeners();
      return {
        'success': true,
        'user': user,
        'hasProfile': hasProfile,
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'error': _getAuthErrorMessage(e.code),
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'An unexpected error occurred',
      };
    }
  }

  // Google Sign-In
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return {'success': false, 'error': 'Sign in cancelled'};
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        return {'success': false, 'error': 'Authentication failed'};
      }

      // Check if user profile exists
      final profileDoc = await _firestore.collection('users').doc(user.uid).get();
      final hasProfile = profileDoc.exists;

      notifyListeners();
      return {
        'success': true,
        'user': user,
        'hasProfile': hasProfile,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Google Sign-In failed: $e',
      };
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    notifyListeners();
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'Email already in use';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return 'Authentication error occurred';
    }
  }
}
