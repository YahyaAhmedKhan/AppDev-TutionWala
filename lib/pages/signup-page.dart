import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tution_wala/helper/auth_functions.dart';
import 'package:tution_wala/pages/login-page.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:tution_wala/providers/firestore_provider.dart';
import 'package:tution_wala/providers/toggle_provider.dart';
import 'package:tution_wala/service/auth_service.dart';
import 'package:tution_wala/service/firestore_service.dart';
import 'package:tution_wala/widgets/toggle_switch.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isObscure = true; // Variable to track password visibility

  void toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  bool checkPasswordsMatch() {
    return passwordController.text == confirmPasswordController.text;
  }

  void handleSignUp(WidgetRef ref) async {
    final email = emailController.text;
    final password = passwordController.text;
    final role = ref.read(toggleSwitchProvider);
    final roleMap = {"Student": "STUDENT", "Tutor": "TUTOR"};

    AuthService authService = ref.read(authServiceProvider);

    try {
      final UserCredential userCredential = await authService
          .signUpWithEmailAndPassword(email, password, roleMap[role]!);
      print("new user via authservice:");

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginPage()));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 1, milliseconds: 500),
          backgroundColor: Colors.green,
          content: Text(
            "User created successfully!",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          )));
    } on FirebaseAuthException catch (e) {
      print("Sign up failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 1, milliseconds: 500),
          content: Text(e.code,
              style:
                  const TextStyle(fontWeight: FontWeight.w400, fontSize: 18))));
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     "Current user: ${ref.read(authServiceProvider).getCurrentUser() == null ? ref.read(authServiceProvider).getCurrentUser()!.email : null}");

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logoPicture(context),
              const Text("Sign Up",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 34,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: _isObscure, // Toggle visibility based on state
                decoration: InputDecoration(
                  hintText: "Password",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: toggleObscure, // Toggle password visibility
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: _isObscure, // Toggle visibility based on state
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: toggleObscure, // Toggle password visibility
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // add switch here

              ToggleSwitch(),
              SizedBox(height: 14),
              signUpButton(ref),
              SizedBox(height: 14),
              alreadyHaveAnAccountLine(context),
              SizedBox(height: 14),
              googleSignInButton(context)
            ],
          ),
        ),
      ),
    );
  }

  SizedBox logoPicture(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * .25,
        child: Image.asset("lib/assets/tutionwala-logo.png"));
  }

  ElevatedButton googleSignInButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      )),
      onPressed: () async {
        UserCredential? userCreds = await signInWithGoogle();
        print("user creds: $userCreds");
        navigateToHomePage(context);
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "lib/assets/google-logo.png",
                    height: 18.0,
                    width: 24,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 24, right: 8),
                    child: Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  RichText alreadyHaveAnAccountLine(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        children: [
          const TextSpan(
            text: "Already have an account? ",
          ),
          TextSpan(
              text: "Sign in",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                }),
        ],
      ),
    );
  }

  SizedBox signUpButton(WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => handleSignUp(ref),
        style: ButtonStyle(
            // elevation: MaterialStateProperty.all(2),
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xffbcec7e)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                // side: const BorderSide(
                //     color: Colors.black,
                //     ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            )),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
