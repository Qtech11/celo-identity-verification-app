import 'package:celo_identity_verification/set_identity_screen.dart';
import 'package:celo_identity_verification/verify_identity_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        home: BottomNavBar(),
      ),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;

  List<Widget> screens = [
    const SetIdentityScreen(),
    const VerifyIdentityScreen(),
  ];

  void _onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: "Set Identity",
            icon: Icon(Icons.settings),
          ),
          BottomNavigationBarItem(
            label: "Verify Identity",
            icon: Icon(Icons.verified_outlined),
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        elevation: 12,
        showUnselectedLabels: true,
        onTap: _onTapped,
      ),
    );
  }
}
