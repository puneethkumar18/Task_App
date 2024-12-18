import 'package:flutter/material.dart';

Color strengthnColor(Color color, double factor) {
  int r = (color.red * factor).clamp(0, 255).toInt();
  int g = (color.green * factor).clamp(0, 255).toInt();
  int b = (color.blue * factor).clamp(0, 255).toInt();

  return Color.fromARGB(color.alpha, r, g, b);
}

List<DateTime> generateWeekDates(int dateOffSet) {
  final today = DateTime.now();
  DateTime startOfTheWeek = today.subtract(Duration(days: today.weekday - 1));

  startOfTheWeek = startOfTheWeek.subtract(Duration(days: dateOffSet * 7));

  return List.generate(
    7,
    (index) => startOfTheWeek.add(
      Duration(days: index),
    ),
  );
}

String rgbToHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}

Color hexToRGB(String hexColor) {
  return Color(int.parse(hexColor, radix: 16) + 0xFF000000);
}
