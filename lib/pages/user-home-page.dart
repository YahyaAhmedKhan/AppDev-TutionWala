import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tution_wala/pages/auth_check_page.dart';
import 'package:tution_wala/pages/contracts_page.dart';
import 'package:tution_wala/pages/tutor_list_page.dart';
import 'package:tution_wala/providers/auth_state_notifier.dart';
import 'package:tution_wala/providers/tutors_provider.dart';
import 'package:tution_wala/service/auth_service.dart';
import 'package:tution_wala/style/color_style.dart';
import 'package:tution_wala/widgets/ongoing_contract_list.dart';
import 'package:tution_wala/widgets/pending_contracts_page.dart';
import 'package:tution_wala/widgets/side_drawer.dart';
import 'package:tution_wala/widgets/tutor_list.dart';

class UserHomePage extends ConsumerStatefulWidget {
  const UserHomePage({super.key});

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends ConsumerState<UserHomePage> {
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
      drawer: SideDrawer(),
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
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          TutorsListPage(),
          SearchTutorsPage(),
          ContractsPage(),
          ProfilePage(),
        ],
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Material(
          elevation: 3,
          color: Color.fromARGB(255, 124, 229, 127),
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
                  icon: FaIcon(FontAwesomeIcons.houseChimney),
                  label: 'Home',
                  selectedIcon: Material(
                    color: Colors.transparent,
                    elevation: 10,
                    shape: CircleBorder(),
                    child: FaIcon(
                      FontAwesomeIcons.houseChimney,
                      color: Colors.white,
                    ),
                  ),
                ),
                NavigationDestination(
                  tooltip: 'Search tutors',
                  icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                  label: 'Search tutors',
                  selectedIcon: Material(
                    color: Colors.transparent,
                    elevation: 10,
                    shape: CircleBorder(),
                    child: FaIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: Colors.white,
                    ),
                  ),
                ),
                NavigationDestination(
                  tooltip: "Contracts",
                  icon: FaIcon(FontAwesomeIcons.fileCirclePlus),
                  label: 'Contracts',
                  selectedIcon: Material(
                    color: Colors.transparent,
                    elevation: 10,
                    shape: CircleBorder(),
                    child: FaIcon(
                      FontAwesomeIcons.fileCirclePlus,
                      color: Colors.white,
                    ),
                  ),
                ),
                NavigationDestination(
                  icon: FaIcon(FontAwesomeIcons.userPen),
                  tooltip: "Profile",
                  label: 'Profile',
                  selectedIcon: Material(
                    color: Colors.transparent,
                    elevation: 10,
                    shape: CircleBorder(),
                    child: FaIcon(
                      FontAwesomeIcons.userPen,
                      color: Colors.white,
                    ),
                  ),
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

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profile Page',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }
}
