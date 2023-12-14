import 'package:intl/intl.dart';

import 'climate.dart';

class DayClimate {
  DayClimate({
    required this.climate,
    required this.title,
    required this.date,
  });

  final DateTime date;
  final Climate? climate;
  final String title;

  String get formattedDate {
    return DateFormat.yMd().format(date);
  }
}

class DayWeather {
  DayWeather({
    required this.climate,
    required this.dayClimates,
  });

  final Climate? climate;
  final List<DayClimate> dayClimates;
}
