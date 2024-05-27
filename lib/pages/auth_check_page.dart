import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/models/account.dart';
import 'package:tution_wala/pages/create_account_page.dart';
import 'package:tution_wala/pages/login-page.dart';
import 'package:tution_wala/pages/user-home-page.dart';
import 'package:tution_wala/service/firestore_service.dart';
import 'package:tution_wala/style/font_style.dart';

class AuthCheckPage extends ConsumerStatefulWidget {
  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends ConsumerState<AuthCheckPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthState();
    });
  }

  Future<void> _checkAuthState() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      // User is signed in, fetch account data
      DocumentSnapshot accountDoc =
          await FirestoreService().getAccountSnapshotById(firebaseUser.uid);
      if (accountDoc.exists) {
        Account account = Account.fromFirestore(accountDoc);
        ref.read(accountProvider.notifier).state = account;
        // Navigate to home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserHomePage()),
        );
      } else {
        // Handle the case where the account document does not exist
        print('Account document does not exist.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CreateAccountPage()),
        );
      }
    } else {
      // User is not signed in, show login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // While checking auth state, show a loading indicator
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
