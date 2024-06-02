import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/pages/auth_check_page.dart';
import 'package:tution_wala/pages/tutor_pending_contracts_page.dart';
import 'package:tution_wala/pages/tutor_weekly_schedule.dart';
import 'package:tution_wala/providers/auth_state_notifier.dart';
import 'package:tution_wala/providers/tutor_weekly_schedule_provider.dart';
import 'package:tution_wala/service/auth_service.dart';
import 'package:tution_wala/style/color_style.dart';
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
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          HomePage(),
          SearchTutorsPage(),
          TutorPendingContractsPage(),
          ProfilePage(),
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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Material(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(
                    16), // adjust the radius value to your liking
                bottom: Radius.circular(
                    16), // adjust the radius value to your liking
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 20, top: 20),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.calendar_today,
                          size: 34,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Weekly Schedule ",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              // color: Colors.white
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: refreshButton(),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: WeeklyScheduleWidget(),
                  ))
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Expanded(
          child: Center(),
        ),
      ],
    );
  }
}

class refreshButton extends ConsumerWidget {
  const refreshButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        print("hi");
        ref.refresh(weeklyScheduleProvider);
      },
      child: Icon(
        Icons.refresh,
        size: 34,
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
