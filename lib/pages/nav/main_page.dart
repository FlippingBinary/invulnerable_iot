import 'package:flutter/material.dart';
import 'package:invulnerable_iot/pages/nav/advice_page.dart';
import 'package:invulnerable_iot/pages/nav/devices_page.dart';
import 'package:invulnerable_iot/pages/nav/home_page.dart';
import 'package:invulnerable_iot/pages/nav/learning_page.dart';
import 'package:invulnerable_iot/pages/nav/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  List pages = [
    HomePage(),
    AdvicePage(),
    DevicesPage(),
    LearningPage(),
    SettingsPage(),
  ];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: Colors.grey.withOpacity(0.6),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_outlined),
              activeIcon: Icon(Icons.notifications),
              label: 'Advice'),
          BottomNavigationBarItem(
              icon: Icon(Icons.devices_outlined),
              activeIcon: Icon(Icons.devices),
              label: 'Inventory'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_library_outlined),
              activeIcon: Icon(Icons.local_library),
              label: 'Learning'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings'),
        ],
      ),
    );
  }
}
