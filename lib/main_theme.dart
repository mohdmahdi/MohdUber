import 'package:flutter/material.dart';

ThemeData mainTheme = ThemeData(
  primaryColor: Color(0xffEFBC06),
  primaryColorLight: Color(0xffF9F5EA),

  fontFamily: 'SFPro',
  textTheme: TextTheme(
    title: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF636363),
        letterSpacing: 1.2 ,height: 1.5),
    subhead: TextStyle(color: Color(0xFF636363), letterSpacing: 1.2 , height: 1.5),
  ),
);
