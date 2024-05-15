import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tution_wala/helper/auth_functions.dart';
import 'package:tution_wala/pages/login-page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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

  void handleSignUp() async {
    final email = emailController.text;
    final password = passwordController.text;

    print("signing up with: $email, $password");

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      print("user created: $email");

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 1, milliseconds: 500),
          backgroundColor: Colors.green,
          content: Text(
            "User created successfully!",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          )));
    } on FirebaseAuthException catch (e) {
      print("could not sign up: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 1, milliseconds: 500),
          content: Text(
            e.code,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                handleSignOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (checkPasswordsMatch()) {
                      handleSignUp();
                    } else
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 1, milliseconds: 500),
                          content: Text("Passwords do not match")));
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  )),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginPage()), // Replace LoginPage with the actual name of your login page class
                    );
                  },
                  child: const Text(
                    "Already have an account? Sign in",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
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
                child: SizedBox(
                  width: double.infinity,
                  child: Expanded(
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
