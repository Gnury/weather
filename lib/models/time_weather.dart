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

  const TimeWeather({
    required this.temperatureInCelsius,
    required this.dateTime,

  });
}