import 'package:flutter/material.dart';
import 'package:invernova/screens/alarms.dart';
import 'package:invernova/screens/configuration.dart';
import 'package:invernova/screens/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
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
        title: const Text('Perfil de Usuario'),
      ),
          bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexNavigation,
        backgroundColor: const Color.fromARGB(204, 255, 255, 255),
        selectedItemColor: const Color.fromARGB(197, 46, 200, 105),
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
      )
    );
  }
}