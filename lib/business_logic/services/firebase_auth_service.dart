import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../presentation/widgets/utils.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get firebaseUserStream => _firebaseAuth.authStateChanges();
  User? get user => _firebaseAuth.currentUser;

  

  // Sign Up with email and password
  Future<User?> signUpWithEmailPassword(String email, String password, int userType) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        // Create a new document for the user with userType
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'userType': userType,
        });
      }
      return user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        showToast(_handleFirebaseAuthException(e));
      } else {
        showToast("An unknown error occurred.");
      }
      return null;
    }
  }

  // Sign In with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        showToast(_handleFirebaseAuthException(e));
      } else {
        showToast("An unknown error occurred.");
      }
      return null;
    }
  }

  // Handles FirebaseAuthException and returns a user-friendly message
  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return "Email address is invalid.";
      case 'user-disabled':
        return "This user has been disabled.";
      case 'user-not-found':
      case 'wrong-password':
        return "Incorrect email or password.";
      case 'weak-password':
        return "Password is too weak.";
      case 'email-already-in-use':
        return "Email is already in use by another account.";
      default:
        return "An error occurred, please try again later.";
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
