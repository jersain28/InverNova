import 'package:flutter/material.dart';
//import 'package:invernova/screens/alarms_screen.dart';
//import 'package:invernova/screens/home_screen.dart';
//import 'package:invernova/screens/profile_screen.dart';
import 'package:invernova/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _paginaActual = 0;

  final List<Widget> _paginas = [
    const SignupScreen(),
    //const HomeScreen(),
    //const AlarmsScreen(),
    //const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text(
            'InverNova',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold),
          ),
        ),
        body: _paginas[_paginaActual],
        // Botones de navegación inferiores
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _paginaActual = index;
            });
          },
          currentIndex: _paginaActual,
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
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

