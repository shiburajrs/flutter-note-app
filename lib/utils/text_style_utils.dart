import 'package:flutter/material.dart';

class TextStyles {
  // Default values for font properties
  static const double defaultFontSize = 16.0;
  static const Color defaultColor = Colors.black;

  // Bold TextStyle
  static TextStyle bold({
    double fontSize = defaultFontSize,
    Color color = defaultColor,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  // Medium TextStyle
  static TextStyle medium({
    double fontSize = defaultFontSize,
    Color color = defaultColor,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  // Regular TextStyle
  static TextStyle regular({
    double fontSize = defaultFontSize,
    Color color = defaultColor,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: color,
    );
  }

  // Light TextStyle
  static TextStyle light({
    double fontSize = defaultFontSize,
    Color color = defaultColor,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize,
      fontWeight: FontWeight.w300,
      color: color,
    );
  }

  // ExtraLight TextStyle
  static TextStyle extraLight({
    double fontSize = defaultFontSize,
    Color color = defaultColor,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize,
      fontWeight: FontWeight.w200,
      color: color,
    );
  }

  // ExtraBold TextStyle
  static TextStyle extraBold({
    double fontSize = defaultFontSize,
    Color color = defaultColor,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: color,
    );
  }

  // Black TextStyle
  static TextStyle black({
    double fontSize = defaultFontSize,
    Color color = defaultColor,
  }) {
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      color: color,
    );
  }
}
