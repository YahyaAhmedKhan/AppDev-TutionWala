import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } on Exception catch (e) {
    // TODO
    print('exception->$e');
  }
}

Future<bool> signOutFromGoogle() async {
  try {
    await GoogleSignIn().signOut();
    return true;
  } catch (e) {
    // Handle sign out error
    return false;
  }
}

void handleSignOut() async {
  try {
    GoogleSignIn googleSignIn = GoogleSignIn();

    if (await googleSignIn.isSignedIn() != null) {
      await googleSignIn.signOut();

      print(
          "signed out google account, current google account: ${googleSignIn.currentUser}");
    }

    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    print(
        "after signing out, firebase user: ${FirebaseAuth.instance.currentUser}, google user: ${googleSignIn.currentUser}");
  } catch (e) {
    print("Error signing out, error: $e");
  }
}

void navigateToHomePage(BuildContext context) {
  // Navigator.pushAndRemoveUntil(
  //   context,
  //   MaterialPageRoute(
  //       builder: (context) =>
  //           HomePage(email: FirebaseAuth.instance.currentUser!.email!)),
  //   (route) => false,
  // );
}
