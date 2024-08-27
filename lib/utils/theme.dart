import 'package:flutter/material.dart';

const Color themeGreen = Color(0xff4caf50);
const Color themeRed = Color(0xfff44336);

const List<Color> themeSpace = [
  Color(0xff3F5C60),
  Color(0xff2D464B),
  Color(0xff20363C),
  Color(0xff182C32),
];

const List<Color> themePumice = [
  Color(0xffE0E5E0),
  Color(0xffC9CFC9),
  Color(0xffA8AEA8),
  Color(0xff878E87),
];

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: themeSpace[3],
    primary: themePumice[0],
    secondary: themeSpace[0],
    tertiary: themeSpace[1],
    inversePrimary: themeSpace[2],
    inverseSurface: themePumice[1],
    onSecondary: themePumice[0],
  ),
  textTheme: ThemeData().textTheme.apply(bodyColor: themePumice[0]),
);

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.light(
    surface: themePumice[0],
    primary: themeSpace[2],
    secondary: themeSpace[2],
    tertiary: themeSpace[0],
    inversePrimary: themePumice[0],
    inverseSurface: themeSpace[1],
    onSecondary: themePumice[0],
  ),
  textTheme: ThemeData().textTheme.apply(bodyColor: themePumice[0]),
);
