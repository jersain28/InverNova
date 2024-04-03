import 'package:flutter/material.dart';
import 'package:invernova/screens/alarms.dart';
import 'package:invernova/screens/configuration.dart';
import 'package:invernova/screens/humidity.dart';
import 'package:invernova/screens/lights.dart';
import 'package:invernova/screens/temperature.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int indexNavigation = 0;

  openScreen(int index, BuildContext context){
    MaterialPageRoute ruta = MaterialPageRoute(builder: (context) => const HomeScreen());

 switch (index) {
    case 0:
      ruta = MaterialPageRoute(builder: (context) => const HomeScreen());
      break;
    case 1:
      ruta = MaterialPageRoute(builder: (context) => const Alarms());
      break;
    case 2:
      ruta = MaterialPageRoute(builder: (context) => const Configuration());
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
        title: const Text('Invernova 🌱',
        style: TextStyle(
          fontSize: 30,
          color: Colors.white,  
        ),
        ),
        automaticallyImplyLeading: false,
      ),
          body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Temperature()),
              );
            },
            child: buildCard('Temperatura'),
          ),
          const Divider(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Humidity()),
              );
            },
            child: buildCard('Humedad'),
          ),
          const Divider(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Ligths()),
              );
            },
            child: buildCard('Luminosidad'),
          ),
        ],
      ),
        bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(204, 255, 255, 255),
        selectedItemColor: const Color.fromARGB(197, 46, 200, 105),
        currentIndex: indexNavigation,
        onTap: (index) => openScreen(index, context),
        items:const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Alarms'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuracion'
            ),
        ],
      ),
    );
  }

  Widget buildCard(String title) {
    return Card(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(15),
        color: const Color.fromARGB(255, 215, 237, 199),
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),  
              ),
            const SizedBox(height: 100),
              Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Contenido de $title',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
