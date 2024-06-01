import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/pages/auth_check_page.dart';
import 'package:tution_wala/providers/toggle_provider.dart';
import 'package:tution_wala/service/auth_service.dart';
import 'package:tution_wala/service/firestore_service.dart';
import 'package:tution_wala/style/color_style.dart';
import 'package:tution_wala/widgets/toggle_switch.dart';

class CreateRolePage extends ConsumerStatefulWidget {
  const CreateRolePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateRolePageState();
}

class _CreateRolePageState extends ConsumerState<CreateRolePage> {
  bool _isAsyncCallRunning = false;

  void handleSignUp(WidgetRef ref) async {
    final role = ref.read(toggleSwitchProvider);
    final roleMap = {"Student": "STUDENT", "Tutor": "TUTOR"};
    final email = AuthService().getCurrentUserEmail()!;

    AuthService authService = AuthService();

    setState(() {
      _isAsyncCallRunning = true;
    });

    try {
      // await Future.delayed(Duration(seconds: 1));
      // throw Exception("d");

      final documentReference =
          await FirestoreService().addUserRole(email, roleMap[role]!);
      print(documentReference);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthCheckPage()),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 1, milliseconds: 500),
          backgroundColor: Colors.green,
          content: Text(
            "User created successfully!",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          )));
    } catch (e) {
      print("Sign up failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 1, milliseconds: 500),
          content: Text("$e",
              style:
                  const TextStyle(fontWeight: FontWeight.w400, fontSize: 18))));
    } finally {
      setState(() {
        _isAsyncCallRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                AuthService().signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AuthCheckPage()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () {
                print(AuthService().getCurrentUserEmail());
                print(AuthService().getCurrentUser() != null
                    ? AuthService().getCurrentUser()!.uid
                    : null);
              },
              icon: const Icon(Icons.person))
        ],
      ),
      backgroundColor: ColorStyles.primaryGreen, // Light background
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width *
              0.8, // Adjust the width as needed
          // height: MediaQuery.of(context).size.height *
          //     0.6, // Adjust the width as needed
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white, // White container
            borderRadius: BorderRadius.circular(30), // Rounded borders
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0), // no offset, shadow is beneath the widget
                blurRadius: 40, // blur effect
                spreadRadius: 1, // spread effect
                color: Colors.grey.shade500, // shadow color
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Choose Role",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Icon(
                    CupertinoIcons.person_add_solid,
                    size: 40,
                  ),
                ),
                Text(
                  'Please choose which role you are signing up for.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ToggleSwitch(
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                signUpButton(ref),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox signUpButton(WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: MaterialButton(
        onPressed: _isAsyncCallRunning
            ? null
            : () {
                handleSignUp(ref);
              },
        color: const Color(0xffbcec7e),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: _isAsyncCallRunning
            ? Center(
                child: Transform.scale(
                  scale: 0.5,
                  child: CircularProgressIndicator(),
                ),
              )
            : Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
