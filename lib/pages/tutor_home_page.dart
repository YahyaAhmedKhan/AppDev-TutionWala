import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/pages/auth_check_page.dart';
import 'package:tution_wala/pages/tutor_pending_contracts_page.dart';
import 'package:tution_wala/pages/tutor_profile_page.dart';
import 'package:tution_wala/pages/tutor_weekly_schedule.dart';
import 'package:tution_wala/pages/weekly_schedule_page.dart';
import 'package:tution_wala/providers/auth_state_notifier.dart';
import 'package:tution_wala/providers/tutor_weekly_schedule_provider.dart';
import 'package:tution_wala/service/auth_service.dart';
import 'package:tution_wala/style/color_style.dart';
import 'package:tution_wala/widgets/side_drawer.dart';
import 'package:tution_wala/widgets/tutor_pending_contract_list.dart';

class TutorHomePage extends ConsumerStatefulWidget {
  const TutorHomePage({super.key});

  @override
  _TutorHomePageState createState() => _TutorHomePageState();
}

class _TutorHomePageState extends ConsumerState<TutorHomePage> {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.read(authStateProvider);

    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 202, 255, 202),
      backgroundColor: ColorStyles.primaryGreen,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              });
        }),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
              ref.read(authStateProvider.notifier).logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => AuthCheckPage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {
              print(AuthService().getCurrentUserEmail());
              print(AuthService().getCurrentUser() != null
                  ? AuthService().getCurrentUser()!.uid
                  : null);
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      drawer: SideDrawer(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          WeeklySchedulePage(),
          SearchTutorsPage(),
          TutorPendingContractsPage(),
          TutorProfilePage(),
        ],
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(25),
          child: Theme(
            data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent),
            child: NavigationBar(
              animationDuration: const Duration(milliseconds: 100),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              height: 70,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedIndex: _selectedIndex,
              indicatorColor: Colors.transparent,
              indicatorShape: const CircleBorder(),
              onDestinationSelected: _onItemTapped,
              destinations: const [
                NavigationDestination(
                  tooltip: "Home",
                  icon: Icon(Icons.home),
                  label: 'Home',
                  selectedIcon: Icon(Icons.home, size: 32, color: Colors.green),
                ),
                NavigationDestination(
                  tooltip: 'Search tutors',
                  icon: Icon(Icons.search),
                  label: 'Search tutors',
                  selectedIcon:
                      Icon(Icons.search, size: 32, color: Colors.green),
                ),
                NavigationDestination(
                  tooltip: "Contracts",
                  icon: Icon(Icons.format_list_bulleted_add),
                  label: 'Contracts',
                  selectedIcon: Icon(Icons.format_list_bulleted_add,
                      size: 32, color: Colors.green),
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  tooltip: "Profile",
                  label: 'Profile',
                  selectedIcon:
                      Icon(Icons.person, size: 32, color: Colors.green),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchTutorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Search for Tutors Page',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}
