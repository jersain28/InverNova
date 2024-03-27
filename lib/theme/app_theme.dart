import 'package:flutter/material.dart';



class AppTheme{
  // Colores primarios
  static const primaryColor = Color.fromRGBO(27, 96, 25, 0.925);
  // Colores de fondo
  static const backColor = Color.fromRGBO(255, 255, 255, 1);
  // Color secundario
  static const secondaryColor = Color.fromRGBO(255, 255, 255, 0.996);
  // Color del tema
  static final ThemeData ligthTheme = ThemeData().copyWith(
    scaffoldBackgroundColor: backColor,
    appBarTheme: const AppBarTheme(
      color: primaryColor,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold
      )
    ),
  );
}