import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/pages/auth_check_page.dart';
import 'package:tution_wala/pages/login-page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tution_wala/style/font_style.dart';

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
        textTheme: fontTheme,
        useMaterial3: true,
      ),
      home: AuthCheckPage(),
    );
  }
}
