import 'package:flutter/material.dart';
import 'screens/setup_screen.dart';
import 'services/notification_service.dart'; // Import de ton nouveau service

Future<void> main() async {
  // 1. Indispensable pour les services qui utilisent du code natif (Notifications/Storage)
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 2. Initialisation du moteur de notifications
    await NotificationService.init();

    // 3. Planification automatique de la dose de 5h00
    // Cette fonction s'assure que même si l'app est fermée, le système s'en souvient
    await NotificationService.scheduleDaily5AMQuote();
    
    print("Système de notifications initialisé pour 05:00.");
  } catch (e) {
    print("Erreur lors de l'initialisation des services : $e");
  }

  runApp(const BeWiseApp());
}

class BeWiseApp extends StatelessWidget {
  const BeWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeWise Premium',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        // Utilisation de ColorScheme pour les versions récentes de Flutter
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Georgia',
      ),
      home: const SetupScreen(),
    );
  }
}