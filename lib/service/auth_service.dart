import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:tution_wala/providers/toggle_provider.dart';
import 'package:tution_wala/service/firestore_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FirestoreService _firestoreService;

  UserCredential? userCredential;
  AuthService(this._firebaseAuth, this._firestoreService);

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password, String role) async {
    try {
      UserCredential newUser = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      userCredential = newUser;
      print("firestore in :${_firestoreService}");
      DocumentReference? documentReference =
          await _firestoreService.addUserRole(email, role);
      print(documentReference);
      return newUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}

// Update the authServiceProvider to include the FirestoreService
final authServiceProvider = Provider<AuthService>((ref) {
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreService = ref.read(firestoreServiceProvider);
  return AuthService(firebaseAuth, firestoreService);
});

class AuthState {
  final UserCredential? userCredential;
  final bool isLoggedIn;
  final String? errorMessage;

  AuthState({
    this.userCredential,
    this.isLoggedIn = false,
    this.errorMessage,
  });
}

// Future<UserCredential?> signInWithGoogle() async {
//   try {
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//     final GoogleSignInAuthentication? googleAuth =
//         await googleUser?.authentication;

//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth?.accessToken,
//       idToken: googleAuth?.idToken,
//     );

//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   } on Exception catch (e) {
//     // TODO
//     print('exception->$e');
//   }
// }

// Future<bool> signOutFromGoogle() async {
//   try {
//     await GoogleSignIn().signOut();
//     return true;
//   } catch (e) {
//     // Handle sign out errorxp
//     return false;
//   }
// }

// void handleSignOut() async {
//   try {
//     GoogleSignIn googleSignIn = GoogleSignIn();

//     if (await googleSignIn.isSignedIn() != null) {
//       await googleSignIn.signOut();

//       print(
//           "signed out google account, current google account: ${googleSignIn.currentUser}");
//     }

//     await FirebaseAuth.instance.signOut();
//     await googleSignIn.signOut();
//     print(
//         "after signing out, firebase user: ${FirebaseAuth.instance.currentUser}, google user: ${googleSignIn.currentUser}");
//   } catch (e) {
//     print("Error signing out, error: $e");
//   }
// }

// void navigateToHomePage(BuildContext context) {
//   // Navigator.pushAndRemoveUntil(
//   //   context,
//   //   MaterialPageRoute(
//   //       builder: (context) =>
//   //           HomePage(email: FirebaseAuth.instance.currentUser!.email!)),
//   //   (route) => false,
//   // );
// }
