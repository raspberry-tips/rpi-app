import 'package:flutter/material.dart';

import 'screens/main_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RpiApp());
}

class RpiApp extends StatelessWidget {
  const RpiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'raspberry.tips',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
