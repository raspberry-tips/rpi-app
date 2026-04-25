import 'package:flutter/material.dart';

import 'devices/devices_screen.dart';
import 'scanner/scanner_screen.dart';
import 'tools/tools_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _devicesRefreshKey = 0;

  void _onTabSelected(int i) {
    setState(() {
      // Geräte-Tab neu laden wenn er geöffnet wird
      if (i == 2) _devicesRefreshKey++;
      _selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const ScannerScreen(),
          const ToolsScreen(),
          DevicesScreen(key: ValueKey(_devicesRefreshKey)),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onTabSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wifi_find_outlined),
            selectedIcon: Icon(Icons.wifi_find),
            label: 'Scanner',
          ),
          NavigationDestination(
            icon: Icon(Icons.build_outlined),
            selectedIcon: Icon(Icons.build),
            label: 'Tools',
          ),
          NavigationDestination(
            icon: Icon(Icons.devices_outlined),
            selectedIcon: Icon(Icons.devices),
            label: 'Geräte',
          ),
        ],
      ),
    );
  }
}
