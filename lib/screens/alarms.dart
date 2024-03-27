import 'package:flutter/material.dart';
import 'package:invernova/screens/services/notification_service.dart';

class Alarms extends StatefulWidget {
  const Alarms({super.key});

  @override
  State<Alarms> createState() => _AlarmsState();
}

class _AlarmsState extends State<Alarms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarms'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            mostrarNotificacion();
          },
          child: const Text('Show notification'),
        ),
      ),
    );
  }
}