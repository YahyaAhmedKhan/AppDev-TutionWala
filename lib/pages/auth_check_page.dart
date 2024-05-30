import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/models/account.dart';
import 'package:tution_wala/pages/create_student_account_page.dart';
import 'package:tution_wala/pages/create_tutor_account_page.dart';
import 'package:tution_wala/pages/login-page.dart';
import 'package:tution_wala/pages/tutor_home_page.dart';
import 'package:tution_wala/pages/user-home-page.dart';
import 'package:tution_wala/providers/auth_state_notifier.dart';
import 'package:tution_wala/service/auth_service1.dart';
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
    User? firebaseUser = AuthService().getCurrentUser();

    // if firebaseAuth user is signed in already
    if (firebaseUser != null) {
      // User is signed in, fetch Account data
      DocumentSnapshot accountDoc =
          await FirestoreService().getAccountSnapshotById(firebaseUser.uid);

      // auth state notifier object
      AuthStateNotifier authStateNotifier =
          ref.read(authStateProvider.notifier);

      String? role = await FirestoreService().getUserRole(firebaseUser.email!);

      authStateNotifier.state
          .update(email: firebaseUser.email, uid: firebaseUser.uid, role: role);

      // if Account is made completely, redirect to User home page
      if (accountDoc.exists) {
        Account account = Account.fromFirestore(accountDoc);

        // update auth state with account information, isLoggedIn = true
        authStateNotifier.login(account);

        // Navigate to home page
        if (role == 'STUDENT') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserHomePage()),
          );
        } else if (role == 'TUTOR') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TutorHomePage()),
          );
        } else
          print("unknown role in user-roles: $role");
      }
      // if Account not made, redirect to Account Creation
      else {
        print('Account document does not exist.');

        String? role = await FirestoreService()
            .getUserRole(ref.read(authStateProvider).email!);

        if (role == 'STUDENT') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CreateAccountPage()),
          );
        } else if (role == 'TUTOR') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CreateTutorAccountPage()),
          );
        } else
          print("unknown role in user-roles: $role");
      }

      // if not signed in, redirect to Login Page
    } else {
      // User is not signed in, show login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // While checking auth state, show a loading indicator
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
