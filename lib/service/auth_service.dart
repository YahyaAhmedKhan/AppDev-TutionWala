import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tution_wala/providers/toggle_provider.dart';
import 'package:tution_wala/service/firestore_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirestoreService _firestoreService;
  final GoogleSignIn _googleSignIn;
  late AuthState _authState;

  AuthService(this._firebaseAuth, this._firestoreService, this._googleSignIn);

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      _authState.user = userCredential.user;
      return true;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password, String role) async {
    try {
      UserCredential newUserCreds = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      _authState.user = newUserCreds.user;
      print("firestore in :${_firestoreService}");
      DocumentReference? documentReference =
          await _firestoreService.addUserRole(email, role);
      print(documentReference);
      return newUserCreds;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      print("Sign out successful!");
      print("Current user: ${_firebaseAuth.currentUser}");
      print("Current google user: ${_googleSignIn.currentUser}");
    } catch (e) {
      print("Error signing out, error: $e");
    }
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  String? getCurrentUserRole() {
    return _authState.role;
  }

  void handleSignOut() async {}
}

final authServiceProvider = Provider<AuthService>((ref) {
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreService = ref.read(firestoreServiceProvider);
  final googleSignIn = GoogleSignIn();

  final authState = AuthState(
    user: firebaseAuth.currentUser,
  );

  return AuthService(firebaseAuth, firestoreService, googleSignIn);
});

class AuthState {
  User? user;
  final bool isLoggedIn;
  String? role;

  AuthState({
    this.user,
    this.isLoggedIn = false,
  });

  Future<void> fetchRole() async {
    if (user != null) {}
  }
}
