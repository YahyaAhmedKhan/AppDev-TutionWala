import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tution_wala/constants/image_paths.dart';
import 'package:tution_wala/models/tutor.dart';
import 'package:tution_wala/pages/auth_check_page.dart';
import 'package:tution_wala/providers/auth_state_notifier.dart';
import 'package:tution_wala/providers/current_role_provider.dart';
import 'package:tution_wala/service/auth_service.dart';
import 'package:tution_wala/style/color_style.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        // padding: EdgeInsets.zero,
        children: [
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: ColorStyles.primaryGreen,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    ClipOval(
                      child: Image.asset(
                        boyPics[Random().nextInt(4)],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Consumer(
                      builder: (context, watch, child) {
                        final role = ref.read(authStateProvider).account?.role;

                        if (role == null) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "Error getting role",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          );
                        }
                        String string = '';

                        if (role == 'STUDENT') {
                          final studentAsyncValue = ref.read(studentProvider);

                          return studentAsyncValue.when(
                            data: (student) {
                              // Use the tutor's first name in a Text widget
                              return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  "${student.firstName} ${student.lastName}" ??
                                      '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              );
                            },
                            loading: () => Transform.scale(
                                scale: 0.7,
                                child:
                                    const CircularProgressIndicator()), // Show loading indicator while data is being fetched
                            error: (error, stackTrace) => Text(
                                'Error: $error'), // Show error message if fetching fails
                          );
                        } else if (role == 'TUTOR') {
                          final tutorAsyncValue = ref.read(tutorProvider);

                          return tutorAsyncValue.when(
                            data: (tutor) {
                              // Use the tutor's first name in a Text widget
                              return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  "${tutor.firstName} ${tutor.lastName}" ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              );
                            },
                            loading: () => Transform.scale(
                                scale: 0.7,
                                child:
                                    const CircularProgressIndicator()), // Show loading indicator while data is being fetched
                            error: (error, stackTrace) => Text(
                                'Error: $error'), // Show error message if fetching fails
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              'Error',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Expanded(child: Center()),
          InkWell(
            onTap: () async {
              // Navigate to the login screen
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              child: InkWell(
                onTap: () async {
                  await AuthService().signOut();
                  ref.read(authStateProvider.notifier).logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AuthCheckPage()),
                    (route) => false,
                  );
                },
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: const [],
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign out',
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 10),
                          FaIcon(
                            FontAwesomeIcons.rightFromBracket,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
