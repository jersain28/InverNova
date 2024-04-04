import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invernova/screens/alarms.dart';
import 'package:invernova/screens/configuration.dart';
import 'package:invernova/screens/home_screen.dart';
import 'package:uuid/uuid.dart';


class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<PerfilScreen> {
  int _indiceSeleccionado = 0; // Se usa _ para variables privadas
  File? _imagenSeleccionada; // Para almacenar la imagen elegida 


  Future<void> _elegirImagen() async {
    final imagenElegida = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imagenElegida != null) {
        setState(() {
            _imagenSeleccionada = File(imagenElegida.path);
        });
    }
  }

  Future<void> _subirImagen() async {
    try {
      final referenciaImagen = firebase_storage.FirebaseStorage.instance.ref('imagenes_perfil/${const Uuid().v4()}');
      final tareaSubida = referenciaImagen.putFile(_imagenSeleccionada!);
      await tareaSubida;
      final urlImagen = await referenciaImagen.getDownloadURL();
      // Almacena la URL en tu base de datos o úsala como necesites
      print('Imagen subida exitosamente: $urlImagen');
    } catch (error) {
      print('Error al subir la imagen: $error');
      // Muestra una barra emergente o un diálogo al usuario con un mensaje de error
    }
  } 


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
            GestureDetector(
                      onTap: () => _elegirImagen(),
                      child: Container(
                        height: 400,
                        decoration: BoxDecoration(
                        image: _imagenSeleccionada != null
                          ? DecorationImage(
                              image: FileImage(_imagenSeleccionada!),
                              fit: BoxFit.fill,  
                          )
                          : null,
                        ),
                        child: _imagenSeleccionada == null
                        ? const CircleAvatar( radius: 160, backgroundColor: Color.fromARGB(90, 125, 123, 123))
                        : null,
                        ),
                    ),
                    ElevatedButton(
                      onPressed: _imagenSeleccionada != null ? () async => _subirImagen() : null,
                      child: _imagenSeleccionada != null ? const Text('Guardar') : const Text('Selecciona una Imagen'),
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
                              onPressed: () async {
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Información de perfil guardada'),
                                  ),
                                );
                              },
                              child: const Text('Guardar'),
                            ),
                          ],
                        ),
                      ),
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
