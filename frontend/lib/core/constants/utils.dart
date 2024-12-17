import 'dart:ui';

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
