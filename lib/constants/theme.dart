import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: Colors.white,
        onPrimary: Colors.black,
        secondary: Colors.deepPurpleAccent,
        onSecondary: Colors.white,
      ),
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: ThemeData.dark().colorScheme.copyWith(
        primary: Colors.blueGrey,
        onPrimary: Colors.white,
        secondary: Colors.blueGrey,
        onSecondary: Colors.white,
      ),
);
