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

  openScreen(int index, BuildContext context) {
    MaterialPageRoute ruta =
        MaterialPageRoute(builder: (context) => const HomeScreen());

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
        title: const Text(
          'Invernova 🌱',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
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
          IconButton(
            icon: const Hero(
              tag: 'lightbulb',
              child: Icon(
                Icons.lightbulb_outline,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              _showTipsDialogMain(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Temperature(),
                ),
              );
            },
            child: buildCard(
              'Temperatura',
              'assets/images/Temperatura.png',
             const Color.fromARGB(255, 255, 146, 50),
             ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Humidity()),
              );
            },
            child: buildCard(
              'Humedad',
              'assets/images/Humedad.png',
              const Color.fromARGB(255, 55, 192, 255),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Ligths()),
              );
            },
            child: buildCard(
              'Luminosidad',
              'assets/images/Luminosidad.png',
              const Color.fromARGB(255, 248, 255, 50),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(204, 255, 255, 255),
        selectedItemColor: const Color.fromARGB(197, 46, 200, 105),
        currentIndex: indexNavigation,
        onTap: (index) => openScreen(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Alertas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración'),
        ],
      ),
    );
  }

  Widget buildCard(String title, String imagePath, Color color) {
    return Card(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(15),
        color: color,
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                  Shadow(
                    blurRadius: 1,
                    color: Colors.black,
                    offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Monitoreo en tiempo real de $title',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 1,
                      color: Colors.black,
                      offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showTipsDialogMain(BuildContext context) {
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
                  title: Text('Sobre el monitoreo de datos'),
                  subtitle: Text(
                      'La información recopilada con los sensores se actualiza constantemente, esta información te ayudará a mantener los valores de temperatura, humedad y luminosidad dentro del rango óptimo, ya sea para un cultivo de jitomate o cualquier otro tipo de hortalizas.'),
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
