import 'package:flutter/material.dart';

class AppTheme{

  //Colors
  static Color primaryColor=Colors.blueGrey;
  static Color creditColor=Colors.orange[100];
  static Color debitColor=Colors.pink[100];
  static Color balanceColor=Colors.orange[300];

  //Icon colors
  static Color deleteColor=Colors.red;
  static Color generalIconColor=primaryColor;

  //Fonts style
  static TextStyle userStyle=TextStyle(
    fontSize: 28,
    color: primaryColor,
    fontWeight: FontWeight.bold
  );

  static TextStyle generalTextStyle=TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.w600
  );


  //Padding and margins
  static const double generalOutSpacing=20.0;
  static const double smallSpacing=7.0;

  //Item height and width
  static const double listItemHeight=150;
}