import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/pages/login-page.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w900, // Inter-Black
            fontSize: 32.0,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w800, // Inter-ExtraBold
            fontSize: 28.0,
          ),
          displaySmall: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700, // Inter-Bold
            fontSize: 24.0,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600, // Inter-SemiBold
            fontSize: 20.0,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500, // Inter-Medium
            fontSize: 18.0,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400, // Inter-Regular
            fontSize: 16.0,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400, // Inter-Regular
            fontSize: 14.0,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300, // Inter-Light
            fontSize: 12.0,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500, // Inter-Medium
            fontSize: 14.0,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400, // Inter-Regular
            fontSize: 12.0,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600, // Inter-SemiBold
            fontSize: 14.0,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300, // Inter-Light
            fontSize: 12.0,
          ),
          labelSmall: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w200, // Inter-ExtraLight
            fontSize: 10.0,
          ),
        ),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}
