import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
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
      if (i == 2) _devicesRefreshKey++;
      _selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.wifi_find_outlined),
            selectedIcon: const Icon(Icons.wifi_find),
            label: l.navScanner,
          ),
          NavigationDestination(
            icon: const Icon(Icons.build_outlined),
            selectedIcon: const Icon(Icons.build),
            label: l.navTools,
          ),
          NavigationDestination(
            icon: const Icon(Icons.devices_outlined),
            selectedIcon: const Icon(Icons.devices),
            label: l.navDevices,
          ),
        ],
      ),
    );
  }
}
