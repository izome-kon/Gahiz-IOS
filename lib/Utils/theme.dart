/*
This is file to any thing for design in app ex.(colors,themeData,gradients...)
*/

import 'package:flutter/material.dart';

// color for facebook logo
Color faceBookColor = Color.fromRGBO(47, 137, 197, 1);
//primary color in app

Color primaryColor = Color.fromRGBO(1, 153, 212, 1.0);
//accent color in app
Color accentColor = Color.fromRGBO(1, 207, 158, 1.0);

//white color in app
Color whiteColor = Colors.white;
//red color in app
Color redColor = Color.fromRGBO(255, 122, 122, 1);
Color fontColor = Color.fromRGBO(83, 83, 83, 1);
Color dangerColor = Color(0xffdc3545);
// light background in app
Color lightBGColor = Color.fromRGBO(255, 248, 248, 1);
Color shimmerBase = Colors.grey.shade50;
Color shimmerHighlighted = Colors.grey.shade200;
// this font used in title text in app
String headerEnglishFont = "headerEnglishFont";
// this font used in subtitle1 text in app
String bodyEnglishFont = "bodyEnglishFont";

// this font used in subtitle1 text in app
String logoFont = "logoFont";
String arabicFontMedium = "arabicFont-Medium";
String arabicFontLight = "arabicFont-Light";
// this is theme for app
ThemeData myThemeData = ThemeData(
    primaryColor: primaryColor,
    accentColor: accentColor,
    backgroundColor: lightBGColor,
    fontFamily: 'Almarai');
