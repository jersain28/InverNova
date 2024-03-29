import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HeatMeter extends StatefulWidget {
  const HeatMeter(Key key) : super(key: key);

  @override
  _HeatMeterState createState() => _HeatMeterState();
}

class _HeatMeterState extends State<HeatMeter> {
  double _widgetPointerWithGradientValue = 60;

  @override
  Widget build(BuildContext context) {
    return SfLinearGauge(
      maximum: 80.0,
      interval: 20.0,
      minorTicksPerInterval: 0,
      animateAxis: true,
      labelFormatterCallback: (String value) {
        return value + '°c';
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
          value: _widgetPointerWithGradientValue,
          offset: 26,
          position: LinearElementPosition.outside,
          child: SizedBox(
            width: 55,
            height: 45,
            child: Center(
              child: Text(
                _widgetPointerWithGradientValue.toStringAsFixed(0) + '°C',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: _widgetPointerWithGradientValue < 20
                      ? Colors.green
                      : _widgetPointerWithGradientValue < 60
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
              _widgetPointerWithGradientValue = value as double;
            });
          },
          value: _widgetPointerWithGradientValue,
          color: _widgetPointerWithGradientValue < 20
              ? Colors.green
              : _widgetPointerWithGradientValue < 60
                  ? Colors.orange
                  : Colors.red,
        ),
      ],
    );
  }
}
