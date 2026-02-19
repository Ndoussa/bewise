import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/setup_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  // Indispensable pour utiliser SharedPreferences avant runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  final String userName = prefs.getString('userName') ?? "";

  runApp(MotivationApp(isFirstTime: isFirstTime, userName: userName));
}

class MotivationApp extends StatelessWidget {
  final bool isFirstTime;
  final String userName;
  
  const MotivationApp({super.key, required this.isFirstTime, required this.userName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
      // Si c'est la 1ère fois, SetupScreen, sinon HomeScreen
      home: isFirstTime ? const SetupScreen() : HomeScreen(userName: userName),
    );
  }
}