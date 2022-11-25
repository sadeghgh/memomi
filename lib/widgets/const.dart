import 'package:flutter/material.dart';

class Consts {
  static const textStyleOne =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.black);

  static const headingTextStyle =
      TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);

  static const colorA = Color(0xFFCE93D8);
  static const colorB = Color(0xFFE040FB);
  static const appBarColor = Color(0xFFAA00FF);
  static const backGroundColor = Color(0xFFF3E5F5);

  static AppBar appBar = AppBar(
    backgroundColor: appBarColor,
    foregroundColor: backGroundColor,
  );
}
