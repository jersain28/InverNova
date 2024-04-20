import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_database/firebase_database.dart'; 

class WaterLevel extends StatefulWidget {
  // ignore: use_super_parameters
  const WaterLevel({Key? key}) : super(key: key);

  @override
  State<WaterLevel> createState() => WaterLevelState();
}

class WaterLevelState extends State<WaterLevel> {
  late DatabaseReference humidityRef;
  late double humidity = 0.0;

  @override
  void initState() {
    super.initState();
    humidityRef = FirebaseDatabase.instance.ref().child('datos_humedad');
    humidityRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && data.containsKey('humedad')) {
        setState(() {
          final humidityString = data['humedad'].toString();
          final cleanedHumidityString = double.tryParse(humidityString) ?? 0.0;
          humidity = cleanedHumidityString;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Humedad del Suelo',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          RotatedBox(
            quarterTurns: 3, 
            child: SfLinearGauge(
              minimum: 0,
              maximum: 100,
              interval: 10,
              axisTrackStyle: const LinearAxisTrackStyle(
                thickness: 2,
              ),
              markerPointers: <LinearMarkerPointer>[
                LinearWidgetPointer(
                  value: humidity,
                  enableAnimation: false,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.lightBlueAccent,
                          Colors.blueAccent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: const Icon(
                      Icons.opacity_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Nivel de Humedad: ${humidity.toStringAsFixed(2)}%',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}