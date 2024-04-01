import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void>initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('in_notification');

  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  
}

Future<void>mostrarNotificacion(String titulo, String mensaje) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        importance: Importance.max,
        priority: Priority.high,
      );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    1,
    'Alerta Configurada',
    'Se ha agregado una nueva alerta',
    notificationDetails
  );
}
void mostrarAlertaTemperatura() {
  mostrarNotificacion('Alerta de Temperatura Agregada', 'Se ha agregado una nueva alerta');
}

void mostrarAlertaHumedad() {
  mostrarNotificacion('Alerta de Humedad Agregada', 'Se ha agregado una nueva alerta');
}

void mostrarAlertaLuminosidad() {
  mostrarNotificacion('Alerta de Luminosidad Agregada', 'Se ha agregado una nueva alerta');
}