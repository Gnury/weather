import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

enum Climate {
  sunny,
  cloudy,
  dayRainy,
  thunder,
  moon,
  nightRainy,
  windy,
}

var climateImages = {
  Climate.sunny: 'assets/images/sunny.png',
  Climate.cloudy: 'assets/images/cloudy.png',
  Climate.dayRainy: 'assets/images/dayrainy.png',
  Climate.thunder: 'assets/images/thunder.png',
  Climate.moon: 'assets/images/moon.png',
  Climate.nightRainy: 'assets/images/nightrainy.png',
  Climate.windy: 'assets/images/windy.png',
};

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
    return formatter.format(date);
  }
}

class DayWeather {
  DayWeather({
    required this.climate,
    required this.dayClimates,
  });

  final Climate? climate;
  final List<DayClimate> dayClimates;

//   DayWeather.forClimate(List<DayClimate> allClimates, this.climate)
//       : climates = allClimates
//             .where((dayclimate) => climate. == climate)
//             .toList();
}
