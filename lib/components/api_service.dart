import 'package:dio/dio.dart';
import 'package:weather_report/components/cities.dart';
import 'package:weather_report/components/response_forecast_weather.dart';
import 'package:weather_report/components/response_weather.dart';
import 'package:weather_report/models/daily_weather.dart';
import 'package:weather_report/models/day_weather.dart';
import 'package:weather_report/models/time_weather.dart';
import 'package:weather_report/models/city_name.dart';
import 'package:weather_report/util/app_logger.dart';

class ApiService {
  final Dio dio = Dio();

  ApiService._internal();

  static final _singleton = ApiService._internal();

  factory ApiService() => _singleton;

  Future<DailyWeather> getCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'appid': '8b06f7a92d32f24e637b47f97a25ca06',
        },
      );
      var data = response.data;

      final weather = ResponseWeather.fromJson(data);

      final temperatureInKelvin = weather.main.temp;
      final temperatureInCelsius = temperatureInKelvin - 273.15;
      final temperatureInFahrenheit = temperatureInCelsius * 9 / 5 + 32;
      final humidityNow = weather.main.humidity;
      final highTempInKelvin = weather.main.tempMax;
      final highTempInCelsius = highTempInKelvin - 273.15;
      final highTempInFahrenheit = highTempInCelsius * 9 / 5 + 32;
      final lowTempInKelvin = weather.main.tempMin;
      final lowTempInCelsius = lowTempInKelvin - 273.15;
      final lowTempInFahrenheit = lowTempInCelsius * 9 / 5 + 32;
      return DailyWeather(
        temperatureInCelsius: temperatureInCelsius.toInt(),
        temperatureFahrenheit: temperatureInFahrenheit.toInt(),
        dateTime: DateTime.now(),
        humidity: humidityNow,
        highTempInCelsius: highTempInCelsius.toInt(),
        highTemperatureFahrenheit: highTempInFahrenheit.toInt(),
        lowTempInCelsius: lowTempInCelsius.toInt(),
        lowTemperatureFahrenheit: lowTempInFahrenheit.toInt(),
      );
    } catch (error) {
      print('error = $error');
      rethrow;
    }
  }

  Future<ThisWeather> getForecastWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/forecast',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        queryParameters: {
          'lat': latitude,
          'lon': longitude,
          'appid': '8b06f7a92d32f24e637b47f97a25ca06',
        },
      );
      var data = response.data;

      final forecastWeather = ResponseForecastWeather.fromJson(data);
      final list = forecastWeather.list.map((weather) {
        final temperatureInKelvin = weather.main.temp;
        final temperatureInCelsius = temperatureInKelvin - 273.15;
        final temperatureInFahrenheit = temperatureInCelsius * 9 / 5 + 32;
        final firstWeather = weather.weather.firstOrNull;
        final description = firstWeather?.description?.name;

        logger.i("weather(${weather.dtTxt}) weather: ${weather.weather}, description: $description");

        final Climate? climates;
        if(firstWeather?.description == Description.Clear_Sky){
          climates = Climate.sunny;
        }else if(firstWeather?.description == Description.Cloudy){
          climates = Climate.cloudy;
        }else if(firstWeather?.description == Description.Rainy){
          climates = Climate.dayRainy;
        }else if(firstWeather?.description == Description.Storm){
          climates = Climate.thunder;
        }else if(firstWeather?.description == Description.Few_Cloud) {
          climates = Climate.cloudy;
        }else if(firstWeather?.description == Description.Sunny){
          climates = Climate.sunny;
        }else{
          climates = null;
        }

        return TimeWeather(
          temperatureInCelsius: temperatureInCelsius.toInt(),
          temperatureFahrenheit: temperatureInFahrenheit.toInt(),
          dateTime: weather.dtTxt,
          title: description,
          climate: climates,
        );
      }).toList();

      return ThisWeather(
        city: forecastWeather.city.name,
        list: list,
      );
    } catch (error) {
      print('error = $error');
      rethrow;
    }
  }

  Future<CityName> getCities({required String q}) async {
    try {
      final response = await dio.get(
        'http://api.openweathermap.org/geo/1.0/direct',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        queryParameters: {
          'q': q,
          'appid': '8b06f7a92d32f24e637b47f97a25ca06',
        },
      );
      var data = response.data;

      final cities = Cities.fromJson(data);
      return CityName(name: cities.name);
    } catch (error) {
      print('error = $error');
      rethrow;
    }
  }
}
