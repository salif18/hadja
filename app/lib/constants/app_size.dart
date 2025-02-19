import 'package:flutter/material.dart';

class AppSizes{
  //SIZE
  static const double fontSmall = 12;
  static const double fontMedium = 14;
  static const double fontLarge = 16;
  static const double fontHyperLarge = 20;

// PADDING
  static const double paddingSmall = 8;
  static const double paddingMedium = 16;
  static const double paddingLarge = 20;
  

  // PADDING
  static const double iconSmall = 14;
  static const double iconMedium = 16;
  static const double iconLarge = 24;

  // Méthode pour rendre les valeurs responsives
  static double converValueToadapter(BuildContext context, double baseValue) {
    return baseValue / 360;
  }
}