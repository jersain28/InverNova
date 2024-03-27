import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invernova/screens/alarms.dart';
import 'package:invernova/screens/home_screen.dart';
import 'package:invernova/screens/login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
      ruta = MaterialPageRoute(builder: (context) => const Profile());
      break;
  }

  if (index != indexNavigation) {
    setState(() {
      indexNavigation = index;
    });
  }

  Navigator.push(context, ruta);
}

  Future<void> _signOut() async {
  // Redirigir primero a la pantalla de inicio de sesión
  Navigator.pushReplacement(
    // ignore: use_build_context_synchronously
    context,
    MaterialPageRoute(builder: (context) => const LogIn()),
  );

  // Realizar la operación de cierre de sesión
  await _auth.signOut();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                
              },
              child: const Text('Cambiar Foto de Perfil'),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: _signOut,
              child: const Text('Cerrar Sesión'),
            ),
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
            label: 'Alarms'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil'
            ),
        ],
      )
    );
  }
}
