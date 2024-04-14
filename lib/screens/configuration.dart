import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invernova/screens/alarms.dart';
import 'package:invernova/screens/home_screen.dart';
import 'package:invernova/screens/information_screen.dart';
import 'package:invernova/screens/login.dart';
import 'package:invernova/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
    int indexNavigation = 2;

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

  // ignore: unused_element
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('userId');

  await FirebaseAuth.instance.signOut();
  // ignore: use_build_context_synchronously
  Navigator.pushReplacementNamed(context, '/login');
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
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
      ),
      body: Center(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (context)=> const PerfilScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Información'),
              onTap:() {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context)=> const InformationApp(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Cerrar Sesión'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
                  context, 
                  MaterialPageRoute(
                    builder: (context)=> const LogIn(),
                  ),
                  
                );
              },
            ),
           const Divider(),
          ],
        ),
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
          label: 'Alertas'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configuración'
          ),
        ],
      )
    );
  }
}