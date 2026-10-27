import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // El servicio se deja listo para futuras notificaciones en segundo plano.
  // Aquí puede integrarse la lógica de guardado o eventos de alertas.
}

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final StreamController<RemoteMessage> _messageController =
      StreamController<RemoteMessage>.broadcast();

  Stream<RemoteMessage> get messageStream => _messageController.stream;

  Future<void> initialize() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) {
      _messageController.add(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _messageController.add(message);
    });

    final settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await _messaging.getToken();
      // Token disponible para registro del dispositivo con el backend.
      if (token != null) {
        // No se dispara lógica adicional aquí para no romper el flujo actual.
      }
    }
  }

  void dispose() {
    _messageController.close();
  }
}
