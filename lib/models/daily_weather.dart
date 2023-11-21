class DailyWeather {
  final DateTime dateTime;
  final int temperatureInCelsius;
  final int humidity;
  final int highTempInCelsius;
  final int lowTempInCelsius;


  const DailyWeather({
    required this.temperatureInCelsius,
    required this.dateTime,
    required this.humidity,
    required this.highTempInCelsius,
    required this.lowTempInCelsius,
  });
}