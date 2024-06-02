import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tution_wala/pages/auth_check_page.dart';
import 'package:tution_wala/pages/login-page.dart';
import 'package:tution_wala/pages/signup-page.dart';

class TestNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> routes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    routes.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    routes.remove(route);
  }
}

void main() {
  testWidgets('LoginPage UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    // Check for the specific "Login" text with font size 32
    expect(find.text('Login'), findsOneWidget);
    final loginText = find.widgetWithText(Text, 'Login');
    expect(tester.widget<Text>(loginText).style!.fontSize, 32.0);

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text("Don't have an account? "), findsOneWidget);
    expect(find.text('Sign in with Google'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget); // Check for second "Login" text
  });

  testWidgets('LoginPage Functionality Test', (WidgetTester tester) async {
    final TestNavigatorObserver navigatorObserver = TestNavigatorObserver();

    await tester.pumpWidget(MaterialApp(
      home: LoginPage(),
      navigatorObservers: [navigatorObserver],
    ));

    // Tap on the "Sign in with Google" button
    await tester.tap(find.text('Sign in with Google'));
    await tester.pumpAndSettle();

    // Wait for the navigation to AuthCheckPage
    expect(find.byType(LoginPage), findsNothing);
    expect(find.byType(AuthCheckPage), findsOneWidget);

    // Check if LoginPage was properly removed from the widget tree
    expect(navigatorObserver.routes.whereType<LoginPage>(), isEmpty);

    // Tap on the "Sign up" link
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    // Wait for the navigation to SignupPage
    expect(find.byType(LoginPage), findsNothing);
    expect(find.byType(SignupPage), findsOneWidget);
  });
}
