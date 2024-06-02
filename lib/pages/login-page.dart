import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tution_wala/models/account.dart';
import 'package:tution_wala/models/auth_state.dart';
import 'package:tution_wala/pages/auth_check_page.dart';
import 'package:tution_wala/pages/signup-page.dart';
import 'package:tution_wala/pages/user-home-page.dart';
import 'package:tution_wala/providers/auth_state_notifier.dart';
import 'package:tution_wala/service/auth_service.dart';
import 'package:tution_wala/service/firestore_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();

  bool _isAsyncCallRunning = false;

  @override
  void initState() {
    super.initState();
    bool autofill = true;

    emailController =
        TextEditingController(text: autofill ? "a@email.com" : null);
    passwordController =
        TextEditingController(text: autofill ? "123456" : null);
  }

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

  void handleSignIn(WidgetRef ref) async {
    final email = emailController.text;
    final password = passwordController.text;

    print("Signing in with: $email, $password");

    setState(() {
      _isAsyncCallRunning = true;
    });

    try {
      AuthService authService = AuthService();
      User user = await authService.signInWithEmailAndPassword(email, password);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthCheckPage()),
        (route) => false,
      );

      print("Sign in successful");
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Error: ${e.code}",
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 1),
      ));
      print("code: ${e.code}");
    } catch (e) {
      // print(e);
    } finally {
      setState(() {
        _isAsyncCallRunning = false;
      });
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
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
      body: SingleChildScrollView(
        child: loginBody(context, ref),
      ),
    );
  }

  Padding loginBody(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * .25,
              child: Image.asset("lib/assets/tutionwala-logo.png")),
          const SizedBox(height: 20),
          Text(
            'Login',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: toggleShowPassword,
                  icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility)),
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: _isObscure,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          loginButtton(ref),
          const SizedBox(
            height: 14,
          ),
          dontHaveAccountLine(context),
          const SizedBox(
            height: 14,
          ),
          googleSignInButton(context),
        ],
      ),
    );
  }

  RichText dontHaveAccountLine(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        children: [
          const TextSpan(
            text: "Don't have an account? ",
          ),
          TextSpan(
              text: "Sign up",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => SignupPage()),
                      (route) => false);
                }),
        ],
      ),
    );
  }

  ElevatedButton googleSignInButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 14),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      onPressed: () async {
        UserCredential? userCreds = await signInWithGoogle();
        print("user creds: $userCreds");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AuthCheckPage()),
          (route) => false,
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
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
    );
  }

  SizedBox loginButtton(WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: MaterialButton(
        disabledColor: Color.fromARGB(181, 191, 243, 122),
        onPressed: _isAsyncCallRunning ? null : () => handleSignIn(ref),
        color: const Color(0xffbcec7e),
        elevation: 2,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: _isAsyncCallRunning
            ? Center(
                child: Transform.scale(
                  scale: 0.5,
                  child: CircularProgressIndicator(),
                ),
              )
            : const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  "Login",
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
