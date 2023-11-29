import 'package:weather_report/models/day_weather.dart';

class ThisWeather {
  final List<TimeWeather> list;
  final String city;

  const ThisWeather({
    required this.city,
    required this.list,
  });
}

class TimeWeather {
  final DateTime dateTime;
  final int temperatureInCelsius;
  final String? title;
  final Climate? climate;

  const TimeWeather({
    required this.temperatureInCelsius,
    required this.dateTime,
    required this.title,
    required this.climate,

  });
}