import 'package:flutter/material.dart';

class AppColors {
  // Seed Color
  static const Color primarySeed = Colors.green;

  // Status Colors
  static const Color statusAlive = Colors.green;
  static const Color statusDead = Colors.red;
  static const Color statusUnknown = Colors.grey;

  // Gender Colors
  static const Color genderMale = Colors.blue;
  static const Color genderFemale = Colors.pink;
  static const Color genderGenderless = Colors.purple;
  static const Color genderUnknown = Colors.grey;

  // Shimmer Colors
  static final Color shimmerBase = Colors.grey[300]!;
  static final Color shimmerHighlight = Colors.grey[100]!;
  static final Color shimmerBackground = Colors.grey[200]!;
  
  // Text & Icon Colors
  static const Color textGrey = Colors.grey;
  static final Color textGrey300 = Colors.grey[300]!;
  static final Color textGrey500 = Colors.grey[500]!;
  static final Color textGrey600 = Colors.grey[600]!;
  static final Color textGrey100 = Colors.grey[100]!;

  // UI Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color shadow = Colors.black45;
  static final Color errorIcon = Colors.red[300]!;
}
