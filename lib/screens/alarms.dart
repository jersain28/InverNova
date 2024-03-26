import 'package:flutter/material.dart';

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
      body: const Center(
        //child: ElevatedButton(
          //onPressed: () {

          //},
          child: Text('Show notification'),
        //),
      ),
    );
  }
}