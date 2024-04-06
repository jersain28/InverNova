import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:invernova/screens/home_screen.dart';
import 'package:invernova/services/notification_service.dart';

class Alarms extends StatefulWidget {
  // ignore: use_super_parameters
  const Alarms({Key? key}) : super(key: key);

  @override
  State<Alarms> createState() => _AlarmsState();
}

class _AlarmsState extends State<Alarms> {
  late final DatabaseReference _databaseReference;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    _databaseReference =
        FirebaseDatabase.instance.ref().child('datos_humedad');
    _databaseReference.onValue.listen((event) {
      final humidityData = event.snapshot.value as Map<dynamic, dynamic>?; 
      final humidity = humidityData?['humedad'] as String?;
      if (humidity == "H:99.00%") {
        mostrarNotificacion();
      }
    });
    initNotifications();
  }

  int indexNavigation = 0;

  openScreen(int index, BuildContext context) {
    MaterialPageRoute ruta = MaterialPageRoute(
        builder: (context) => const HomeScreen());

    switch (index) {
      case 0:
        ruta = MaterialPageRoute(builder: (context) => const HomeScreen());
        break;
      case 1:
        ruta = MaterialPageRoute(builder: (context) => const Alarms());
        break;
      case 2:
        ruta = MaterialPageRoute(builder: (context) => const Placeholder()); 
        break;
    }

    if (index != indexNavigation) {
      setState(() {
        indexNavigation = index;
      });
    }

    Navigator.push(context, ruta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarms'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            
          },
          child: const Text('show notifications'),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexNavigation,
        backgroundColor: const Color.fromARGB(204, 255, 255, 255),
        selectedItemColor: const Color.fromARGB(197, 46, 200, 105),
        onTap: (index) => openScreen(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Alarms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuracion',
          ),
        ],
      ),
    );
  }
}
