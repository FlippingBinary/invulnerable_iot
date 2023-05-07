import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invulnerable_iot/cubit/app_cubit_states.dart';
import 'package:invulnerable_iot/cubit/app_cubits.dart';
import 'package:invulnerable_iot/pages/nav/strange_page.dart';
import 'package:invulnerable_iot/pages/nav/inventory_page.dart';
import 'package:invulnerable_iot/pages/nav/home_page.dart';
import 'package:invulnerable_iot/pages/nav/learning_page.dart';
import 'package:invulnerable_iot/pages/nav/settings_page.dart';

typedef IntCallback = void Function(int index);

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  List _pages = [];

  @override
  void initState() {
    super.initState();
    // define a single gotoTab that can be shared by each page
    gotoTab(int index) {
      setState(() {
        currentIndex = index;
      });
    }

    _pages.addAll([
      HomePage(gotoTab: gotoTab),
      StrangePage(gotoTab: gotoTab),
      InventoryPage(gotoTab: gotoTab),
      LearningPage(),
      SettingsPage(),
    ]);
  }

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: _pages[currentIndex],
      bottomNavigationBar: BlocBuilder<AppCubits, CubitStates>(
        builder: (context, state) {
          final strangeDevices = (state as PrimaryState)
              .devices
              .where((device) => !device.isAdopted)
              .toList();
          final deviceUpdates = (state as PrimaryState)
              .devices
              .where((device) =>
                  device.isAdopted &&
                  device.services.any((service) => !service.isKnown))
              .toList();
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: theme.colorScheme.background,
            currentIndex: currentIndex,
            onTap: onTap,
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: Colors.grey.withOpacity(0.6),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            // elevation: 0,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home'),
              BottomNavigationBarItem(
                  icon: strangeDevices.isEmpty
                      ? Icon(Icons.settings_remote)
                      : Stack(
                          children: [
                            Icon(Icons.settings_remote),
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.error,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  '${strangeDevices.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                  label: 'Strange Devices'),
              BottomNavigationBarItem(
                  // icon: Icon(Icons.devices_outlined),
                  icon: deviceUpdates.isEmpty
                      ? Icon(Icons.devices_outlined)
                      : Stack(
                          children: [
                            Icon(Icons.devices_outlined),
                            Positioned(
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.error,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  '${deviceUpdates.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                  label: 'Known Devices'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_library_outlined),
                  activeIcon: Icon(Icons.local_library),
                  label: 'Learning'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Settings'),
            ],
          );
        },
      ),
    );
  }
}
