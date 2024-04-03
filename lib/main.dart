import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:invernova/screens/login.dart';
import 'package:invernova/services/notification_service.dart';
import 'package:invernova/theme/app_theme.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //useMaterial3: true,
      //),
      home: const LogIn(),
      theme: AppTheme.ligthTheme,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;

  //void _incrementCounter() {
    //setState(() {
      //_counter++;
    //});
  //}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      //appBar: AppBar(
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //title: Text(widget.title),
      //),
      //body: Center(
        //child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //children: <Widget>[
            //const Text(
              //'You have pushed the button this many times:',
            //),
            //Text(
              //'$_counter',
              //style: Theme.of(context).textTheme.headlineMedium,
            //),
          //],
        //),
      //),
      //floatingActionButton: FloatingActionButton(
        //onPressed: _incrementCounter,
        //tooltip: 'Increment',
        //child: const Icon(Icons.add),
      //),
    );
  }
}