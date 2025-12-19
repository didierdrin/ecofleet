import 'package:flutter/material.dart';

class AppColors {
  // Rwandan Flag Colors
  static const Color primaryBlue = Color(0xFF00A1DE);
  static const Color primaryYellow = Color(0xFFFAD201);
  static const Color primaryGreen = Color(0xFF00A651);

  // Backgrounds & Surfaces
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text
  static const Color textPrimaryLight = Color(0xFF1A1A1A);
  static const Color textSecondaryLight = Color(0xFF6B7280);

  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFA0A0A0);

  // Accent
  static const Color accent = Color(0xFF00A1DE);
}

class AppConstants {
  static const String appName = 'EcoFleet Tracker';
  static const String tagline = 'Smart Green Mobility';
  
  // Kigali Major Roads
  static const List<String> kigaliMajorRoads = [
    'KN 3 Road',
    'KN 4 Avenue',
    'KN 5 Road',
    'KG 9 Avenue',
    'KG 11 Avenue',
    'KK 15 Road',
    'Boulevard de Nyabugogo',
    'Avenue de la République',
    'Boulevard de l\'Umuganda',
    'Avenue Paul VI',
    'Kimironko Road',
    'Remera Road',
  ];
}
