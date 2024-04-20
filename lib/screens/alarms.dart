import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:invernova/screens/configuration.dart';
import 'package:invernova/screens/home_screen.dart';
import 'package:invernova/screens/login.dart';
import 'package:invernova/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Alarm {
  String name;
  RangeValues valueRange;
  bool activated;

  Alarm({
    required this.name,
    required this.valueRange,
    this.activated = true,
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
  int indexNavigation = 1;
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
            SliderWidget(
              values: selectedRange,
              onChanged: (values) {
                setState(() {
                  selectedRange = values;
                });
              },
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
                _saveAlarms();
                _startListeningToTemperatureChanges();
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
                          style: TextButton.styleFrom(
                            foregroundColor: const Color.fromARGB(255, 244, 245, 244),
                            backgroundColor: const Color.fromARGB(255, 0, 175, 6),
                          ),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 244, 245, 244),
                backgroundColor: const Color.fromARGB(255, 0, 175, 6),
              ),
            child: const Text('Guardar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 66, 66, 66),
              ),
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  ).then((_) => _saveAlarms());

}

void _startListeningToTemperatureChanges() {
  final databaseReference = FirebaseDatabase.instance.ref();
  databaseReference.child('datos_temperatura').child('temperatura').onValue.listen((event) {
    final dataSnapshot = event.snapshot;
    final temperaturaActual = dataSnapshot.value.toString();
    final temperaturaNumerica = double.tryParse(temperaturaActual.replaceAll(RegExp(r'[^0-9.]'), ''));
    
    for (Alarm alarm in temperatureAlarms) {
      if (alarm.activated && temperaturaNumerica != null) {
        if (temperaturaNumerica < alarm.valueRange.start) {
          mostrarAlertaTemperaturaBaja();
          break;
        } else if  (temperaturaNumerica > alarm.valueRange.end) {
          mostrarAlertaTemperaturaAlta();
          break;
        }
      }
    }
  });
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
            SliderWidget(
              values: selectedRange,
              onChanged: (values) {
                setState(() {
                  selectedRange = values;
                });
              },
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
                _saveAlarms();
                _startListeningToHumidityChanges(); 
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
                          style: TextButton.styleFrom(
                            foregroundColor: const Color.fromARGB(255, 244, 245, 244),
                            backgroundColor: const Color.fromARGB(255, 0, 175, 6),
                          ),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 244, 245, 244),
              backgroundColor: const Color.fromARGB(255, 0, 175, 6),
            ),
            child: const Text('Guardar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 66, 66, 66),
              ),
            child: const Text('Cancelar'),
          ),
        ],
      );
    },
  ).then((_) => _saveAlarms());
}

void _startListeningToHumidityChanges() {
  final databaseReference = FirebaseDatabase.instance.ref();
  databaseReference.child('datos_humedad').child('humedad').onValue.listen((event) {
    final dataSnapshot = event.snapshot;
    final humedadActual = double.tryParse(dataSnapshot.value.toString());

    for (Alarm alarm in humidityAlarms) {
      if (alarm.activated && humedadActual != null && humedadActual <= alarm.valueRange.start) {
        mostrarAlertaHumedadBaja();
        break;
      } else if (humedadActual! > alarm.valueRange.end) {
        mostrarAlertaHumedadAlta();
        break;
      }
    }
    }
  );
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
              SliderWidget(
                values: selectedRange,
                onChanged: (values) {
                  setState(() {
                    selectedRange = values;
                  });
                },
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
                  _saveAlarms();
                  _startListeningToLuminosityChanges();
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
                            style: TextButton.styleFrom(
                              foregroundColor: const Color.fromARGB(255, 244, 245, 244),
                              backgroundColor: const Color.fromARGB(255, 0, 175, 6),
                            ),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 244, 245, 244),
                backgroundColor: const Color.fromARGB(255, 0, 175, 6),
              ),
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 66, 66, 66),
              ),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    ).then((_) => _saveAlarms());
  }
  void _startListeningToLuminosityChanges() {
  final databaseReference = FirebaseDatabase.instance.ref();
  databaseReference.child('datos_luminosidad').child('luminosidad').onValue.listen((event) {
    final dataSnapshot = event.snapshot;
    final luminosidadActual = _extractLuminosityValue(dataSnapshot.value.toString());
    if (luminosidadActual != null) {
      for (Alarm alarm in luminosityAlarms) {
        if (alarm.activated) {
          if (luminosidadActual <= alarm.valueRange.start) {
            mostrarAlertaLuminosidadBaja();
            break;
          } else if (luminosidadActual > alarm.valueRange.end) {
            mostrarAlertaLuminosidadAlta();
            break;
          }
        }
      }
    }
  });
}

double? _extractLuminosityValue(String luminosityString) {
  try {
    final valueString = luminosityString.split(':').last.replaceAll('%', '').trim();
    return double.tryParse(valueString);
  } catch (e) {
    print('Error al extraer el valor de luminosidad: $e');
    return null;
  }
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
          backgroundColor: const Color.fromARGB(255, 255, 255, 254),
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
              SliderWidget(
              values: selectedRange,
              onChanged: (values) {
                setState(() {
                  selectedRange = values;
                });
              },
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
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 244, 245, 244),
                backgroundColor: const Color.fromARGB(255, 0, 175, 6),
              ),
              child: const Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 66, 66, 66),
              ),
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
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
              Color.fromARGB(255, 21, 235, 28),
              Color.fromARGB(255, 12, 181, 3),
              Color.fromARGB(255, 1, 147, 6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: const Text('Alertas'),
        actions: [
          IconButton(icon: const Hero(
            tag: 'lightbulb',
            child: Icon(Icons.lightbulb_outline,
            color: Colors.white,
            ),
          ),
          onPressed: () {
            _showTipsDialog(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          ElevatedButton(
            onPressed: _addTemperatureAlert,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 1, 186, 8),
            ),
            child: const Text('Agregar alerta de temperatura'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Alertas de Temperatura configuradas:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                      activeTrackColor: const Color.fromARGB(255, 2, 182, 8),
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
          const Divider(),
          ElevatedButton(
            onPressed: _addHumidityAlert,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 1, 185, 7),
            ),
            child: const Text('Agregar alerta de humedad'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Alertas de Humedad configuradas:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                      activeTrackColor: const Color.fromARGB(255, 3, 181, 9),
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
          const Divider(),
          ElevatedButton(
            onPressed: _addLuminosityAlert,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 1, 181, 7),
            ),
            child: const Text('Agregar alerta de luminosidad'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Alertas de Luminosidad configuradas:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                      activeTrackColor: const Color.fromARGB(255, 1, 182, 7),
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
        ],
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
            label: 'Alertas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}

class SliderWidget extends StatefulWidget {
  final RangeValues values;
  final ValueChanged<RangeValues> onChanged;

  const SliderWidget({
    required this.values,
    required this.onChanged,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late double _start;
  late double _end;

 @override
  void initState() {
    super.initState();
    _start = widget.values.start;
    _end = widget.values.end;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RangeSlider(
          values: RangeValues(_start, _end),
          min: 0,
          max: 100,
          divisions: 100,
          onChanged: (values) {
            setState(() {
              _start = values.start;
              _end = values.end;
            });
            widget.onChanged(values);
          },
          activeColor: const Color.fromARGB(255, 10, 163, 2),
          inactiveColor: Colors.grey,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${_start.round()}'),
            Text('${_end.round()}'),
          ],
        ),
      ],
    );
  }
}

void _showTipsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Consejo!'),
          content: const SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    title: Text('Configurando las alertas'),
                    subtitle: Text('Para un óptimo cuidado de tu cultivo de jitomate, te recomendamos configurar una alerta de temperatura, humedad y luminosidad para el día, y configurar una adicional para la noche, de este modo podrás mantener los valores en el rango adecuado en todo momento.'),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }