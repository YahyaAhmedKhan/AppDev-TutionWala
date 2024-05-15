import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tution_wala/helper/auth_functions.dart';
import 'package:tution_wala/pages/signup-page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void handleSignOut() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      if (googleSignIn.currentUser != null) {
        await googleSignIn.signOut();

        print(
            "signed out google account, current google account: ${googleSignIn.currentUser}");
      }

      await FirebaseAuth.instance.signOut();
      print(
          "after singing out, firebase user: ${FirebaseAuth.instance.currentUser}");
    } catch (e) {
      print("Error signing out, error: $e");
    }
  }

  void handleSignIn() async {
    final email = emailController.text;
    final password = passwordController.text;

    print("signing up with: $email, $password");

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;
      print("user signed in: $email");
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => HomePage(
      //             email: FirebaseAuth.instance.currentUser!.email!,
      //           )),
      //   (route) => false,
      // );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Error: ${e.code}",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
      print("code: ${e.code}");
    } catch (e) {
      // print(e);
    }
  }

  bool _isObscure = false;
  void toggleShowPassword() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Current user: ${FirebaseAuth.instance.currentUser}");

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
          padding: const EdgeInsets.fromLTRB(20, 130, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
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
                obscureText: _isObscure,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: toggleShowPassword,
                      icon: Icon(_isObscure
                          ? Icons.visibility_off
                          : Icons.visibility)),
                  hintText: "Password",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handleSignIn,
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
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to the sign-up page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SignupPage()), // Replace SignUpPage with the actual name of your sign-up page class
                  );
                },
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
