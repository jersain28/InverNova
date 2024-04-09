import 'package:flutter/material.dart';
import 'package:invernova/graphic/grafica_temp.dart';
import 'package:invernova/screens/alarms.dart';
import 'package:invernova/screens/configuration.dart';
import 'package:invernova/screens/home_screen.dart';

class Temperature extends StatefulWidget {
  const Temperature({super.key});

  @override
  State<Temperature> createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  int indexNavigation = 0;

  openScreen(int index, BuildContext context) {
    MaterialPageRoute ruta = MaterialPageRoute(builder: (context) => const HomeScreen());

    switch (index) {
      case 0:
        ruta = MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
        break;
      case 1:
        ruta = MaterialPageRoute(builder: (context) => const Alarms());
        break;
      case 2:
        ruta = MaterialPageRoute(
          builder: (context) => const Configuration(),
        );
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
        title: const Text('Temperatura 🌡️'),
        actions: [
          IconButton(icon: const Hero(
            tag: 'lightbulb',
            child: Icon(Icons.lightbulb_outline,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          _showTipsDialogTemperature(context);
          },
        ),        ],
      ),
      body: ListView(
        children: [
          buildCard('Datos'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexNavigation,
        backgroundColor: const Color.fromARGB(204, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(255, 8, 50, 17),
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
            icon: Icon(Icons.person),
            label: 'Perfil',
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
              const HeatMeter(Key('heatMeter')), 
              const SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
}

void _showTipsDialogTemperature(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tip'),
          content: const SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    title: Text('Sobre la Temperatura'),
                    subtitle: Text(''),
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