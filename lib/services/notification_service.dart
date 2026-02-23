import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    
    // Configuration Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuration iOS
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> scheduleDaily5AMQuote() async {
    await _notificationsPlugin.zonedSchedule(
      0,
      'Ta dose de sagesse BeWise',
      'Ouvre l\'application pour découvrir ton inspiration du jour !',
      _nextInstanceOfFiveAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'bewise_daily', 'Inspiration Quotidienne',
          importance: Importance.max,
          priority: Priority.high,
          visibility: NotificationVisibility.public, // <-- AFFICHE SUR ÉCRAN DE VEILLE
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // <-- RÉVEILLE LE TÉLÉPHONE
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // REPRÉSENTE LA RÉPÉTITION QUOTIDIENNE
    );
  }

  static tz.TZDateTime _nextInstanceOfFiveAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 5, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}