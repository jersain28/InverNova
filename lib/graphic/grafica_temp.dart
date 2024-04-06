import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HeatMeter extends StatefulWidget {
  const HeatMeter(Key key) : super(key: key);

  @override
  HeatMeterState createState() => HeatMeterState();
}

class HeatMeterState extends State<HeatMeter> {
  double widgetPointerWithGradientValue = 60;

  @override
  Widget build(BuildContext context) {
    return SfLinearGauge(
      maximum: 80.0,
      interval: 20.0,
      minorTicksPerInterval: 0,
      animateAxis: true,
      labelFormatterCallback: (String value) {
        return '$value°C'; // Utilizando interpolación de cadenas
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
