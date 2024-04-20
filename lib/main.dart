import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:invernova/screens/home_screen.dart';
import 'package:invernova/screens/login.dart';
import 'package:invernova/services/notification_service.dart';
import 'package:invernova/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  // ignore: unused_local_variable
  String? userId = prefs.getString('userId');

  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', user.uid);
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData && snapshot.data != null) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: const HomeScreen(),
            theme: AppTheme.ligthTheme,
          );
        } else {
        return MaterialApp(
          routes: {
            '/login': (context) => const LogIn(),
          },
          debugShowCheckedModeBanner: false,
          home: const LogIn(),
    );
  }
}
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

  @override
  Widget build(BuildContext context) {
    return const Scaffold(

    );
  }
}