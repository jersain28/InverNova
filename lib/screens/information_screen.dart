import 'package:flutter/material.dart';

class InformationApp extends StatefulWidget {
  const InformationApp({super.key});

  @override
  State<InformationApp> createState() => _InformationAppState();
}

class _InformationAppState extends State<InformationApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Información'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descripción:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'InverNova un invernadero inteligente que mejorara la calidad de tus cultivos.',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Funcionalidades Principales:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '- Medicion de temperatura.\n'
              '- Medicion de humedad.\n'
              '- Medicion de luminosidad.\n'
              '- Control de riego.\n',
              style: TextStyle(fontSize: 16.0),
            ),    
            Text(
              'Política de Privacidad:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Todos los derechos reservados',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Términos de Servicio:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Lee nuestros términos de servicio en: www.ejemplo.com/terminos',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Actualizaciones y Novedades:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Descubre las últimas actualizaciones y novedades en: www.ejemplo.com/actualizaciones',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Feedback y Valoraciones:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Tu opinión es importante para nosotros. Por favor, deja tu valoración en la tienda de aplicaciones.',
              style: TextStyle(fontSize: 16.0),
            ),
             SizedBox(height: 20.0),
            Text(
              'Versión:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '1.0',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
