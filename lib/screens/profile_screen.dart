import 'package:flutter/material.dart';
import 'package:invernova/screens/alarms.dart';
import 'package:invernova/screens/configuration.dart';
import 'package:invernova/screens/home_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<PerfilScreen> {
  int _indiceSeleccionado = 0; // Se usa _ para variables privadas

  void _seleccionarElemento(int indice) {
    setState(() {
      _indiceSeleccionado = indice;
      switch (indice) {
        case 0:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const HomeScreen()));
          break;
        case 1:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Alarms()));
          break;
        case 2:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Configuration()));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Aquí va el contenido de tu perfil (imagen, información, etc.)
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/InverNovaLogo1.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Nombre:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Ingrese su nombre',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Email:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Ingrese su email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                 const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ),
            // ... (Agrega más contenido del perfil si es necesario)
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceSeleccionado,
        backgroundColor: const Color.fromARGB(204, 255, 255, 255),
        selectedItemColor: const Color.fromARGB(197, 46, 200, 105),
        onTap: _seleccionarElemento,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Alarmas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}
