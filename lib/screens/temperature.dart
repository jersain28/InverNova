import 'package:flutter/material.dart';
import 'package:invernova/graphic/grafica_temp.dart';
import 'package:invernova/screens/alarms.dart';
import 'package:invernova/screens/configuration.dart';
import 'package:invernova/screens/home_screen.dart';

class Temperature extends StatefulWidget {
  const Temperature({super.key});

  @override
  State<Temperature> createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  int indexNavigation = 0;

  openScreen(int index, BuildContext context) {
    MaterialPageRoute ruta = MaterialPageRoute(builder: (context) => const HomeScreen());

    switch (index) {
      case 0:
        ruta = MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
        break;
      case 1:
        ruta = MaterialPageRoute(builder: (context) => const Alarms());
        break;
      case 2:
        ruta = MaterialPageRoute(
          builder: (context) => const Configuration(),
        );
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
        title: const Text('Temperatura 🌡️'),
      ),
      body: ListView(
        children: [
          buildCard('Datos'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexNavigation,
        backgroundColor: const Color.fromARGB(204, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(255, 8, 50, 17),
        selectedItemColor: const Color.fromARGB(197, 46, 200, 105),
        onTap: (index) => openScreen(index, context),
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
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget buildCard(String title) {
    return Card(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(15),
        color: const Color.fromARGB(255, 215, 237, 199),
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const HeatMeter(Key('heatMeter')), 
              const SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
}

// class HeatMeter extends StatefulWidget {
//   const HeatMeter(Key key) : super(key: key);

//   @override
//   _HeatMeterState createState() => _HeatMeterState();
// }

// class _HeatMeterState extends State<HeatMeter> {
//   double _widgetPointerWithGradientValue = 60;

//   @override
//   Widget build(BuildContext context) {
//     return SfLinearGauge(
//       maximum: 80.0,
//       interval: 20.0,
//       minorTicksPerInterval: 0,
//       animateAxis: true,
//       labelFormatterCallback: (String value) {
//         return value + '°c';
//       },
//       axisTrackStyle: const LinearAxisTrackStyle(thickness: 1),
//       barPointers: <LinearBarPointer>[
//         LinearBarPointer(
//           value: 80,
//           thickness: 24,
//           position: LinearElementPosition.outside,
//           shaderCallback: (Rect bounds) {
//             return const LinearGradient(
//               colors: <Color>[Colors.green, Colors.orange, Colors.red],
//               stops: <double>[0.1, 0.4, 0.9],
//             ).createShader(bounds);
//           },
//         ),
//       ],
//       markerPointers: <LinearMarkerPointer>[
//         LinearWidgetPointer(
//           value: _widgetPointerWithGradientValue,
//           offset: 26,
//           position: LinearElementPosition.outside,
//           child: SizedBox(
//             width: 55,
//             height: 45,
//             child: Center(
//               child: Text(
//                 _widgetPointerWithGradientValue.toStringAsFixed(0) + '°C',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w500,
//                   fontSize: 14,
//                   color: _widgetPointerWithGradientValue < 20
//                       ? Colors.green
//                       : _widgetPointerWithGradientValue < 60
//                           ? Colors.orange
//                           : Colors.red,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         LinearShapePointer(
//           offset: 25,
//           onChanged: (dynamic value) {
//             setState(() {
//               _widgetPointerWithGradientValue = value as double;
//             });
//           },
//           value: _widgetPointerWithGradientValue,
//           color: _widgetPointerWithGradientValue < 20
//               ? Colors.green
//               : _widgetPointerWithGradientValue < 60
//                   ? Colors.orange
//                   : Colors.red,
//         ),
//       ],
//     );
//   }
// }
