import 'package:flutter/material.dart';
import 'package:invernova/graphic/graphic_humi.dart';
import 'package:invernova/screens/alarms.dart';
import 'package:invernova/screens/configuration.dart';
import 'package:invernova/screens/home_screen.dart';

class Humidity extends StatefulWidget {
  const Humidity({super.key});

  @override
  State<Humidity> createState() => _HumidityState();
}

class _HumidityState extends State<Humidity> {
   int indexNavigation = 0;

  openScreen(int index, BuildContext context){
    MaterialPageRoute ruta = MaterialPageRoute(builder: (context) => const HomeScreen());

    switch(index){
      case 0:
      ruta = MaterialPageRoute(
        builder: (context) => const HomeScreen());
      break;
      case 1:
      ruta = MaterialPageRoute(builder: (context) => const Alarms());
      break;
      case 2:
      ruta = MaterialPageRoute(
        builder: (context) => const Configuration());
      break;
    }
    setState(() {
      indexNavigation = index;
      Navigator.push(context, ruta);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Humedad ♒'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
              Color.fromARGB(255, 21, 235, 28),
              Color.fromARGB(255, 12, 181, 3),
              Color.fromARGB(255, 1, 147, 6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          IconButton(icon: const Hero(
          tag: 'lightbulb',
          child: Icon(Icons.lightbulb_outline,
          color: Colors.white,
          ),
        ),
        onPressed: () {
          _showTipsDialogHumidity(context);
          },
        ),
      ],
      ),
      body: ListView(
        children: [buildCard('Datos')],
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
            label: 'Alertas'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
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
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const WaterLevel(),
              Container(
                padding: const EdgeInsets.all(30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showTipsDialogHumidity(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Consejo!'),
          content: const SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    title: Text('Sobre la Humedad'),
                    subtitle: Text('Mantén un ojo en los niveles de humedad para asegurarte de que se encuentre dentro del rango óptimo. Demasiada humedad puede promover el crecimiento de hongos y enfermedades, mientras que muy poca puede causar estrés en tus hortalizas.'),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }