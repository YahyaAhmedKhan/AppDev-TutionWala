import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:tution_wala/pages/auth_check_page.dart';
import 'package:tution_wala/pages/login-page.dart';
import 'package:tution_wala/pages/signup-page.dart';

void main() {
  testGoldens('LoginPage renders correctly', (tester) async {
    // Build the widget
    final widget = ProviderScope(child: MaterialApp(home: SignupPage()));
    await tester.pumpWidgetBuilder(widget);

    // Create a golden test builder
    await screenMatchesGolden(tester, 'login_page');
  });
}
