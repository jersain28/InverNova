import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('in_notification');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> mostrarNotificacion(String titulo, String mensaje) async {
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
      2, // Cambia el ID si lo deseas
      titulo,
      mensaje,
      notificationDetails);
}

void mostrarAlertaTemperaturaBaja() {
  mostrarNotificacion('Alerta',
      'Temperatura Baja');
      
}
void mostrarAlertaTemperaturaAlta(){
  mostrarNotificacion('Alerta',
      'Temperatura Alta');
}

void mostrarAlertaHumedadBaja() {
  mostrarNotificacion('Alerta',
      'Humedad Baja, Comenzará el riego');
}

void mostrarAlertaHumedadAlta() {
  mostrarNotificacion('Alerta',
      'Humedad demasiado alta, el riego se detendrá');
}

void mostrarAlertaLuminosidadBaja() {
  mostrarNotificacion('Alerta',
      'Tu cultivo necesita más luz');
}

void mostrarAlertaLuminosidadAlta() {
  mostrarNotificacion('Alerta',
      'Demasiada luz para tu cultivo');
}