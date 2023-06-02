import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Colors.indigo;

  static final ThemeData darkTheme = ThemeData.dark()
      .copyWith(
        appBarTheme: const AppBarTheme(color: Colors.indigo, elevation: 0),
        
        );
}
