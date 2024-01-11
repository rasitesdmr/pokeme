import 'package:flutter/material.dart';

class AppColorPalette {
  static List<Color> primaryTextColor = [Color(0xFFCEC7BF), Color(0xFF07161B)];
  static Color dividerColor = Colors.white54;
  static List<Color> pageBackgroundColor = [Color(0xFF07161B), Color(0xFF3D737F)];
  static Color menuBackgroundColor = Color(0xFF07161B);
  static Color menuSelectedItemColor = Color(0xFFCEC7BF);
  static Color menuUnselectedItemColor = Color(0xFF9b958f);
  static Color buttonColor = Color(0xFF07161B);

  static Color clockBG = Color(0xFF444974);
  static Color clockOutline = Color(0xFFEAECFF);
  static Color? secHandColor = Colors.orange[300];
  static Color minHandStatColor = Color(0xFF748EF6);
  static Color minHandEndColor = Color(0xFF77DDFF);
  static Color hourHandStatColor = Color(0xFFC279FB);
  static Color hourHandEndColor = Color(0xFFEA74AB);

  static Color stopWatchTourScreenColor = Color(0xFF4F95A5);

  static List<Color> alarmItemBackgraoundColor = [Color(0xFF2E505F), Color(0xFF538F99), Color(0xFFa5a5a5)];
  static List<Color> alarmItemTextColor = [Color(0xFFD9D9D9), Color(0xFF1C3039)];
  static List<Color> alarmItemSwitchBackgroundColor = [Color(0xFFD9D9D9), Color(0xFF538F99)];
  static List<Color> alarmItemSwitchButtonColor = [Color(0xFF538F99), Color(0xFF1C3039), Color(0xFFD9D9D9)];
  static Color alarmAddBackgroundColor = Color(0xFF4F95A5);
  static Color alarmBorderColor = Color(0xFF1C3039);
  static Color alarmDeleteButton = Color(0xFF8e261e);

  static Color alarmAddScreenBackgroundColor = Color(0xFFD9D9D9);
  static Color alaramAddScreenTextColor = Color(0xFF1C3039);
  static Color alaramAddScreenButtonColor = Color(0xFF1C3039);
  static Color alaramAddScreenButtonTextColor = Color(0xFFD9D9D9);


}

class GradientColors {
  final List<Color> colors;
  GradientColors(this.colors);

  static List<Color> sky = [Color(0xFF2E505F), Color(0xFF2E505F)];
  static List<Color> sunset = [Color(0xFF538F99), Color(0xFF538F99)];
  static List<Color> sea = [Color(0xFFa5a5a5), Color(0xFFa5a5a5)];
}

class GradientTemplate {
  static List<GradientColors> gradientTemplate = [
    // Renk listesi düzenlenecek
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.sunset),
    GradientColors(GradientColors.sea),
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.sunset),
    GradientColors(GradientColors.sea),
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.sunset),
    GradientColors(GradientColors.sea),
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.sunset),
    GradientColors(GradientColors.sea),
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.sunset),
    GradientColors(GradientColors.sea),
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.sunset),
    GradientColors(GradientColors.sea),
    GradientColors(GradientColors.sky),
    GradientColors(GradientColors.sunset),
    GradientColors(GradientColors.sea),
    GradientColors(GradientColors.sky),
  ];
}
