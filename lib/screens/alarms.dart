import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:invernova/screens/configuration.dart';
import 'package:invernova/screens/home_screen.dart';
import 'package:invernova/screens/login.dart';
import 'package:invernova/screens/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Alarm {
  String name;
  RangeValues valueRange;
  bool activated;

  Alarm({
    required this.name,
    required this.valueRange,
    this.activated = false,
  });

Map<String, dynamic> toJson() {
    return {
      'name': name,
      'valueRange': [valueRange.start, valueRange.end],
      'activated': activated,
    };
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      name: json['name'],
      valueRange: RangeValues(json['valueRange'][0], json['valueRange'][1]),
      activated: json['activated'],
    );
  }
}

class Alarms extends StatefulWidget {
  const Alarms({super.key});

  @override
  State<Alarms> createState() => _AlarmsState();
}

class _AlarmsState extends State<Alarms> {
  int indexNavigation = 0;
  List<Alarm> temperatureAlarms = [];
  List<Alarm> humidityAlarms = [];
  List<Alarm> luminosityAlarms = [];

  openScreen(int index, BuildContext context){
    MaterialPageRoute ruta = MaterialPageRoute(builder: (context) => const HomeScreen());

    switch (index) {
      case 0:
        ruta = MaterialPageRoute(builder: (context) => const HomeScreen());
        break;
      case 1:
        ruta = MaterialPageRoute(builder: (context) => const Alarms());
        break;
      case 2: 
        ruta = MaterialPageRoute(builder: (context) => const Configuration());
        break;
    }

    if (index != indexNavigation) {
      setState(() {
        indexNavigation = index;
      });
    }

    Navigator.pushReplacement(context, ruta);
  }

  // ignore: unused_element
  Future<void> _signOut() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('temperatureAlarms');
  await prefs.remove('humidityAlarms');
  await prefs.remove('luminosityAlarms');

  await FirebaseAuth.instance.signOut();

  Navigator.pushReplacement(
    // ignore: use_build_context_synchronously
    context,
    MaterialPageRoute(builder: (context) => const LogIn()),
  );
  }

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      _loadAlarms();
    }
  }

  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      temperatureAlarms = _getAlarmsFromPrefs(prefs, 'temperatureAlarms');
      humidityAlarms = _getAlarmsFromPrefs(prefs, 'humidityAlarms');
      luminosityAlarms = _getAlarmsFromPrefs(prefs, 'luminosityAlarms');
    });
  }

  List<Alarm> _getAlarmsFromPrefs(SharedPreferences prefs, String key) {
    final alarmsJson = prefs.getStringList(key);
    if (alarmsJson == null) {
      return [];
    }
    return alarmsJson.map((json) => Alarm.fromJson(jsonDecode(json))).toList();
  }

  Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('temperatureAlarms', temperatureAlarms.map((alarm) => jsonEncode(alarm.toJson())).toList());
    prefs.setStringList('humidityAlarms', humidityAlarms.map((alarm) => jsonEncode(alarm.toJson())).toList());
    prefs.setStringList('luminosityAlarms', luminosityAlarms.map((alarm) => jsonEncode(alarm.toJson())).toList());
  }

  void _toggleAlarmActivation(List<Alarm> alarms, int index) {
    if (alarms.where((alarm) => alarm.activated).length < 2 || alarms[index].activated) {
      setState(() {
        alarms[index].activated = !alarms[index].activated;
        _saveAlarms();
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Alerta'),
            content: const Text('Solo se permiten dos alertas activas simultáneamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _addTemperatureAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String alertName = '';
        RangeValues selectedRange = const RangeValues(0, 100);
        return AlertDialog(
          title: const Text('Agregar Alerta de Temperatura'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  alertName = value;
                },
                decoration: const InputDecoration(labelText: 'Nombre de la alerta'),
              ),
              const SizedBox(height: 20),
              const Text('Selecciona el rango de temperatura deseado:'),
              RangeSlider(
                values: selectedRange,
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (RangeValues values) {
                  selectedRange = values;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${selectedRange.start.round()} °C'),
                  Text('${selectedRange.end.round()} °C'),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (temperatureAlarms.length < 2) {
                  final newAlert = Alarm(
                    name: alertName,
                    valueRange: selectedRange,
                  );
                  setState(() {
                    temperatureAlarms.add(newAlert);
                  });
                  mostrarAlertaTemperatura();
                  Navigator.of(context).pop();
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Alerta'),
                        content: const Text('Solo se permiten dos alertas de temperatura configuradas.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    ).then((_) => _saveAlarms());
  }

  void _addHumidityAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String alertName = '';
        RangeValues selectedRange = const RangeValues(0, 100);

        return AlertDialog(
          title: const Text('Agregar Alerta de Humedad'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  alertName = value;
                },
                decoration: const InputDecoration(labelText: 'Nombre de la alerta'),
              ),
              const SizedBox(height: 20),
              const Text('Selecciona el rango de humedad deseado:'),
              RangeSlider(
                values: selectedRange,
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (RangeValues values) {
                  selectedRange = values;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${selectedRange.start.round()} %'),
                  Text('${selectedRange.end.round()} %'),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (humidityAlarms.length < 2) {
                  final newAlert = Alarm(
                    name: alertName,
                    valueRange: selectedRange,
                  );
                  setState(() {
                    humidityAlarms.add(newAlert);
                  });
                  mostrarAlertaHumedad();
                  Navigator.of(context).pop();
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Alerta'),
                        content: const Text('Solo se permiten dos alertas de humedad configuradas.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    ).then((_) => _saveAlarms());
  }

  void _addLuminosityAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String alertName = '';
        RangeValues selectedRange = const RangeValues(0, 100);
        return AlertDialog(
          title: const Text('Agregar Alerta de Luminosidad'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  alertName = value;
                },
                decoration: const InputDecoration(labelText: 'Nombre de la alerta'),
              ),
              const SizedBox(height: 20),
              const Text('Selecciona el rango de luminosidad deseado:'),
              RangeSlider(
                values: selectedRange,
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (RangeValues values) {
                  selectedRange = values;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${selectedRange.start.round()} lux'),
                  Text('${selectedRange.end.round()} lux'),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (luminosityAlarms.length < 2) {
                  final newAlert = Alarm(
                    name: alertName,
                    valueRange: selectedRange,
                  );
                  setState(() {
                    luminosityAlarms.add(newAlert);
                  });
                  mostrarAlertaLuminosidad();
                  Navigator.of(context).pop();
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Alerta'),
                        content: const Text('Solo se permiten dos alertas de luminosidad configuradas.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    ).then((_) => _saveAlarms());
  }

  void _deleteAlarm(List<Alarm> alarms, int index) {
    setState(() {
      alarms.removeAt(index);
    });
    _saveAlarms();
  }

  void _editAlarm(List<Alarm> alarms, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String alertName = alarms[index].name;
        RangeValues selectedRange = alarms[index].valueRange;
        return AlertDialog(
          title: const Text('Editar Alerta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  alertName = value;
                },
                decoration: const InputDecoration(labelText: 'Nombre de la alerta'),
                controller: TextEditingController()..text = alertName,
              ),
              const SizedBox(height: 20),
              const Text('Selecciona el nuevo rango deseado:'),
              RangeSlider(
                values: selectedRange,
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (RangeValues values) {
                  selectedRange = values;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${selectedRange.start.round()}'),
                  Text('${selectedRange.end.round()}'),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  alarms[index].name = alertName;
                  alarms[index].valueRange = selectedRange;
                });
                _saveAlarms();
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarms'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _addTemperatureAlert,
              child: const Text('Agregar alerta de temperatura'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Alertas de Temperatura configuradas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: temperatureAlarms.length,
                itemBuilder: (context, index) {
                  final alarm = temperatureAlarms[index];
                  return ListTile(
                    title: Text(alarm.name),
                    subtitle: Text('${alarm.valueRange.start.round()} - ${alarm.valueRange.end.round()} °C'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: alarm.activated,
                          onChanged: (value) => _toggleAlarmActivation(temperatureAlarms, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editAlarm(temperatureAlarms, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteAlarm(temperatureAlarms, index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addHumidityAlert,
              child: const Text('Agregar alerta de humedad'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Alertas de Humedad configuradas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: humidityAlarms.length,
                itemBuilder: (context, index) {
                  final alarm = humidityAlarms[index];
                  return ListTile(
                    title: Text(alarm.name),
                    subtitle: Text('${alarm.valueRange.start.round()} - ${alarm.valueRange.end.round()} %'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: alarm.activated,
                          onChanged: (value) => _toggleAlarmActivation(humidityAlarms, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editAlarm(humidityAlarms, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteAlarm(humidityAlarms, index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addLuminosityAlert,
              child: const Text('Agregar alerta de luminosidad'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Alertas de Luminosidad configuradas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: luminosityAlarms.length,
                itemBuilder: (context, index) {
                  final alarm = luminosityAlarms[index];
                  return ListTile(
                    title: Text(alarm.name),
                    subtitle: Text('${alarm.valueRange.start.round()} - ${alarm.valueRange.end.round()} lux'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: alarm.activated,
                          onChanged: (value) => _toggleAlarmActivation(luminosityAlarms, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editAlarm(luminosityAlarms, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteAlarm(luminosityAlarms, index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexNavigation,
        backgroundColor: const Color.fromARGB(204, 255, 255, 255),
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
            icon: Icon(Icons.settings),
            label: 'Configuracion',
          ),
        ],
      ),
    );
  }
}
