import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int _indiceSeleccionado = 2; // Se usa _ para variables privadas
  String _nombreUsuario = '';
  String _imageUrl = '';
  File? _imagenSeleccionada; // Para almacenar la imagen elegida
  final TextEditingController _nombreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    try {
      // Realizar la consulta a Firestore para obtener los datos del usuario actual
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('usuarios')
          .doc(_getIdUsuarioActual())
          .get();

      if (snapshot.exists) {
        setState(() {
          _nombreUsuario = snapshot.data()!['name'];
          _imageUrl = snapshot.data()!['imageUrl'];
          _nombreController.text =
              _nombreUsuario; // Establecer el nombre en el campo de texto
        });
      }
    } catch (error) {
      print('Error al cargar el perfil: $error');
    }
  }

  Future<void> _elegirImagen() async {
    final imagenElegida =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imagenElegida != null) {
      final File imagenSeleccionadaTemp = File(imagenElegida.path);
      setState(() {
        _imagenSeleccionada = imagenSeleccionadaTemp;
        _imageUrl =
            ''; // Reiniciar _imageUrl para mostrar la nueva imagen seleccionada
      });

      final firebase_storage.Reference referenciaImagen = firebase_storage
          .FirebaseStorage.instance
          .ref('imagenes_perfil/${const Uuid().v4()}');
      final firebase_storage.UploadTask tareaSubida =
          referenciaImagen.putFile(_imagenSeleccionada!);
      await tareaSubida;
      final String urlImagen = await referenciaImagen.getDownloadURL();
      print(
          'URL de la imagen seleccionada: $urlImagen'); // Agregado: imprimir la URL de la imagen seleccionada
      setState(() {
        _imageUrl = urlImagen;
      });
    }
  }

  Future<void> _subirImagen(String nombreUsuario) async {
    try {
      final referenciaImagen = firebase_storage.FirebaseStorage.instance
          .ref('imagenes_perfil/${const Uuid().v4()}');
      final tareaSubida = referenciaImagen.putFile(_imagenSeleccionada!);
      await tareaSubida;
      final urlImagen = await referenciaImagen.getDownloadURL();
      print(
          'URL de la imagen subida: $urlImagen'); // Agregado: imprimir la URL de la imagen subida

      setState(() {
        _imageUrl = urlImagen; // Actualizar _imageUrl con la nueva URL
      });

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(_getIdUsuarioActual())
          .set(
        {
          'imageUrl': urlImagen,
          'name': nombreUsuario,
          // Aquí puedes agregar más campos como el nombre y el correo electrónico si lo deseas
        },
        SetOptions(
          merge: true,
        ),
      );

      print('Imagen subida exitosamente: $urlImagen');
    } catch (error) {
      print('Error al subir la imagen: $error');
    }
  }

  String _getIdUsuarioActual() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // Manejo de casos donde el usuario no está autenticado
      return ''; // o puedes manejarlo de otra manera
    }
  }

  Widget _buildProfileImage() {
    if (_imagenSeleccionada != null) {
      return CircleAvatar(
        radius: 80.0,
        backgroundImage: FileImage(_imagenSeleccionada!),
      );
    } else if (_imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 80.0,
        backgroundImage: NetworkImage(_imageUrl),
      );
    } else {
      return const CircleAvatar(
        radius: 80.0,
        child: Icon(
          Icons.person,
          size: 80,
          color: Colors.white,
        ),
      );
    }
  }

  void _seleccionarElemento(int indice) {
    setState(() {
      _indiceSeleccionado = indice;
      switch (indice) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Alarms()),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Configuration()),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text('Perfil de Usuario'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            // Sección para seleccionar una imagen
            GestureDetector(
              onTap: () => _elegirImagen(),
              child: Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(90, 125, 123, 123),
                ),
                child: _imagenSeleccionada != null
                    ? CircleAvatar(
                        radius: 80.0,
                        backgroundImage: FileImage(_imagenSeleccionada!),
                      )
                    : _imageUrl.isNotEmpty
                        ? CircleAvatar(
                            radius: 80.0,
                            backgroundImage: NetworkImage(_imageUrl),
                          )
                        : const CircleAvatar(
                            radius: 80.0,
                            child: Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
              ),
            ),
            const SizedBox(height: 20.0),
            // Campo para ingresar el nombre
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  hintText: 'Ingrese su nombre',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // Botón para guardar los cambios
            ElevatedButton(
              onPressed: () async {
                String nombreUsuario = _nombreController.text;
                if (nombreUsuario.isNotEmpty) {
                  await _subirImagen(nombreUsuario);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Información de perfil guardada'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, ingrese su nombre'),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 244, 245, 244),
                backgroundColor: const Color.fromARGB(255, 0, 175, 6),
              ),
              child: const Text('Guardar'),
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
            label: 'Alertas',
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
