import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_database/firebase_database.dart';

class HeatMeter extends StatefulWidget {
  // ignore: use_super_parameters
  const HeatMeter({Key? key}) : super(key: key);

  @override
  HeatMeterState createState() => HeatMeterState();
}

class HeatMeterState extends State<HeatMeter> {
  late DatabaseReference temperatureRef;
  late double temperature = 0;

  @override
  void initState() {
    super.initState();
    temperatureRef = FirebaseDatabase.instance.ref().child('datos_temperatura');
    temperatureRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && data.containsKey('temperatura')) {
        setState(() {
          final temperatureString = data['temperatura'] as String;
          temperature = double.tryParse(temperatureString) ?? 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SfLinearGauge(
      maximum: 80.0,
      interval: 20.0,
      minorTicksPerInterval: 0,
      animateAxis: true,
      labelFormatterCallback: (String value) {
        return '$value°C';
      },
      axisTrackStyle: const LinearAxisTrackStyle(thickness: 1),
      barPointers: <LinearBarPointer>[
        LinearBarPointer(
          value: temperature,
          thickness: 24,
          position: LinearElementPosition.outside,
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: <Color>[Colors.green, Colors.orange, Colors.red],
              stops: <double>[0.1, 0.4, 0.9],
            ).createShader(bounds);
          },
        ),
      ],
      markerPointers: <LinearMarkerPointer>[
        LinearWidgetPointer(
          value: temperature,
          offset: 26,
          position: LinearElementPosition.outside,
          child: SizedBox(
            width: 55,
            height: 45,
            child: Center(
              child: Text(
                '${temperature.toStringAsFixed(0)}°C', 
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: temperature < 20
                      ? Colors.green
                      : temperature < 60
                          ? Colors.orange
                          : Colors.red,
                ),
              ),
            ),
          ),
        ),
        LinearShapePointer(
          offset: 25,
          onChanged: (dynamic value) {
            setState(() {
              temperature = value as double;
            });
          },
          value: temperature,
          color: temperature < 20
              ? Colors.green
              : temperature < 60
                  ? Colors.orange
                  : Colors.red,
        ),
      ],
    );
  }
}
