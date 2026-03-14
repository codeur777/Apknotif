import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:apknotif/services/controller_page.dart';

// Handler background/terminated — doit être une fonction top-level
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  // Firebase est déjà initialisé par Flutter, pas besoin de le refaire
  print('Background message: ${message.messageId}');
}

class ApiFlutter {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _controller = ControllerPage();

  Future<void> initialize() async {
    // Demande de permission
    await _firebaseMessaging.requestPermission();

    // Token FCM (à copier dans Firebase Console > Test messaging)
    final token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Handler pour les messages reçus en background/terminated
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    // Notification en foreground (app ouverte)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _controller.showNotification(
          id: message.hashCode,
          title: notification.title ?? 'Notification',
          body: notification.body ?? '',
        );
      }
    });

    // App ouverte depuis une notification (background -> foreground)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification ouverte: ${message.data}');
    });

    // App lancée depuis une notification (état terminated)
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print('App lancée via notification: ${initialMessage.data}');
    }
  }
}
