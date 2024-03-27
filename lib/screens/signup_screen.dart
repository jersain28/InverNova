import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:invernova/screens/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController nickName = TextEditingController();
  TextEditingController password = TextEditingController();
  final firebase = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 50, right: 10),
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  hintText: 'Correo electrónico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
              child: TextField(
                controller: fullName,
                decoration: InputDecoration(
                  labelText: 'Nombre completo',
                  hintText: 'Nombre completo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
              child: TextField(
                controller: nickName,
                decoration: InputDecoration(
                  labelText: 'Nombre de usuario',
                  hintText: 'Nombre de usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
              child: TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  hintText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  // Registrar el usuario en Firestore
                  await firebase.collection('usuarios').add({
                    'email': email.text,
                    'fullName': fullName.text,
                    'nickName': nickName.text,
                    'password': password.text
                    // Puedes agregar más campos si es necesario
                  });

                  // Navegar a la pantalla HomeScreen
                  // ignore: use_build_context_synchronously
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => const Home(),
                  //   ),
                  // );
                },
                child: const Text('Registrarte'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
