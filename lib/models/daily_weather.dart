class DailyWeather {
  final DateTime dateTime;
  final int temperatureInCelsius;
  final int temperatureFahrenheit;
  final int humidity;
  final int highTempInCelsius;
  final int highTemperatureFahrenheit;
  final int lowTempInCelsius;
  final int lowTemperatureFahrenheit;


  const DailyWeather({
    required this.temperatureInCelsius,
    required this.temperatureFahrenheit,
    required this.dateTime,
    required this.humidity,
    required this.highTempInCelsius,
    required this.highTemperatureFahrenheit,
    required this.lowTempInCelsius,
    required this.lowTemperatureFahrenheit,
  });
}