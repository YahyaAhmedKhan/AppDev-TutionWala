import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tution_wala/constants/image_paths.dart';
import 'package:tution_wala/pages/auth_check_page.dart';
import 'package:tution_wala/providers/auth_state_notifier.dart';
import 'package:tution_wala/service/auth_service.dart';

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
            child: DrawerHeader(
              child: Column(
                children: [
                  ClipOval(
                    child: Image.asset(
                      boyPics[Random().nextInt(4)],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
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
