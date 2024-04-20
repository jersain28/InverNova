import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_database/firebase_database.dart'; 

class RadialRangeSliderStateTypes extends StatefulWidget {
  const RadialRangeSliderStateTypes(Key key) : super(key: key);

  @override
  RadialRangeSliderStateTypesState createState() => RadialRangeSliderStateTypesState();
}

class RadialRangeSliderStateTypesState extends State<RadialRangeSliderStateTypes> {
  late DatabaseReference luminosityRef;
  late String luminosity = '0'; 

  @override
  void initState() {
    super.initState();
    luminosityRef = FirebaseDatabase.instance.ref().child('datos_luminosidad');
    luminosityRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && data.containsKey('luminosidad')) {
        setState(() {
          final luminosityString = data['luminosidad'] as String;
          final cleanedLuminosityString = luminosityString.replaceAll(RegExp(r'[^0-9.]'), '');
          luminosity = double.tryParse(cleanedLuminosityString)?.toString() ?? '0';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            radiusFactor: 0.8,
            axisLineStyle: AxisLineStyle(
              color: Theme.of(context).brightness == Brightness.light
                ? const Color.fromRGBO(191, 214, 245, 1)
                : const Color.fromRGBO(36, 58, 89, 1),
              thickness: 0.05,
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            ranges: <GaugeRange>[
              GaugeRange(
                endValue: double.parse(luminosity),
                startValue: 0,
                sizeUnit: GaugeSizeUnit.factor,
                color: const Color.fromRGBO(44, 117, 220, 1),
                endWidth: 0.05,
                startWidth: 0.05,
              )
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: double.parse(luminosity),
                elevation: 5,
                enableDragging: false,
                color: const Color.fromRGBO(44, 117, 220, 1),
                markerHeight: 30,
                markerWidth: 30,
                markerType: MarkerType.circle,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Luminosidad: $luminosity',
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Times',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                positionFactor: 0.05,
              )
            ],
          )
        ],
      ),
    );
  }
}
