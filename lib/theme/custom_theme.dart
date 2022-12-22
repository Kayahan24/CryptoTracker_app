// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const PrimaryColor = Color(0xFFfafafa);
const PrimaryColorLight = Color(0xFFffffff);
const PrimaryColorDark = Color(0xFFc7c7c7);

const SecondaryColor = Color(0xFFf5f5f5);
const SecondaryColorLight = Color(0xFFffffff);
const SecondaryColorDark = Color(0xFFc2c2c2);

const Background = Color(0xFFfffdf7);
const TextColor = Color(0xFFffffff);

class CustomTheme {
  static ThemeData get lightTheme {
    //1
    return ThemeData(
      //2
      primaryColor: PrimaryColorLight,
      scaffoldBackgroundColor: PrimaryColorLight,
      fontFamily: 'Montserrat', //3
    );
  }
}
