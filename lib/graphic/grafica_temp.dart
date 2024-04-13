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
  double widgetPointerWithGradientValue = 60;
  late DatabaseReference temperatureRef;
  late String temperature = '0';

  @override
  void initState() {
    super.initState();
    temperatureRef = FirebaseDatabase.instance.ref().child('datos_temperatura');
    temperatureRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && data.containsKey('temperatura')) {
        setState(() {
          final temperatureString = data['temperatura'] as String;
          final cleanedTemperatureString = temperatureString.replaceAll(RegExp(r'[^0-9.]'), '');
          temperature = double.tryParse(cleanedTemperatureString)?.toString() ?? '0';
          widgetPointerWithGradientValue = double.tryParse(cleanedTemperatureString) ?? 0;
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
          value: 80,
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
          value: widgetPointerWithGradientValue,
          offset: 26,
          position: LinearElementPosition.outside,
          child: SizedBox(
            width: 55,
            height: 45,
            child: Center(
              child: Text(
                '${widgetPointerWithGradientValue.toStringAsFixed(0)}°C',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: widgetPointerWithGradientValue < 20
                      ? Colors.green
                      : widgetPointerWithGradientValue < 60
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
              widgetPointerWithGradientValue = value as double;
            });
          },
          value: widgetPointerWithGradientValue,
          color: widgetPointerWithGradientValue < 20
              ? Colors.green
              : widgetPointerWithGradientValue < 60
                  ? Colors.orange
                  : Colors.red,
        ),
      ],
    );
  }
}
