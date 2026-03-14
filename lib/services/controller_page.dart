import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
class ControllerPage {

  final  notificationPlugin = FlutterLocalNotificationsPlugin();
  bool _IsInitialized = false;
  bool get isInitialized =>_IsInitialized;  

  Future<void> initailize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = 
      InitializationSettings(android: androidSettings, iOS: iosSettings);
    await notificationPlugin.initialize(settings: settings);

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    _IsInitialized = true;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async { 
    const androidDetails = AndroidNotificationDetails(
      'Falisco',
      'Falisco test notification',
      importance: Importance.max,
      priority: Priority.high, 
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    await notificationPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
);
  }

}