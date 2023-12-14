import 'package:dio/dio.dart';
import 'package:weather_report/components/cities.dart';
import 'package:weather_report/components/response_forecast_weather.dart';
import 'package:weather_report/components/response_weather.dart';
import 'package:weather_report/components/weather_descriptions.dart';
import 'package:weather_report/models/daily_weather.dart';
import 'package:weather_report/models/time_weather.dart';
import 'package:weather_report/models/city_name.dart';

import '../models/climate.dart';

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
      final firstWeather = weather.weather.firstOrNull;
      
      final Climate? climates;
      if (firstWeather?.description == Description.Clear_Sky) {
        climates = Climate.sunny;
      } else if (firstWeather?.description == Description.Cloudy) {
        climates = Climate.cloudy;
      } else if (firstWeather?.description == Description.Rainy) {
        climates = Climate.dayRainy;
      } else if (firstWeather?.description == Description.Storm) {
        climates = Climate.thunder;
      } else if (firstWeather?.description == Description.Few_Cloud) {
        climates = Climate.cloudy;
      } else if (firstWeather?.description == Description.Sunny) {
        climates = Climate.sunny;
      } else {
        climates = Climate.unicorn;
      }

      return DailyWeather(
        temperatureInCelsius: temperatureInCelsius.toInt(),
        temperatureFahrenheit: temperatureInFahrenheit.toInt(),
        dateTime: DateTime.now(),
        humidity: humidityNow,
        highTempInCelsius: highTempInCelsius.toInt(),
        highTemperatureFahrenheit: highTempInFahrenheit.toInt(),
        lowTempInCelsius: lowTempInCelsius.toInt(),
        lowTemperatureFahrenheit: lowTempInFahrenheit.toInt(),
        climate: climates,
      );
    } catch (error) {
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


        final Climate? climates;
        if (firstWeather?.description == Description.Clear_Sky) {
          climates = Climate.sunny;
        } else if (firstWeather?.description == Description.Cloudy) {
          climates = Climate.cloudy;
        } else if (firstWeather?.description == Description.Rainy) {
          climates = Climate.dayRainy;
        } else if (firstWeather?.description == Description.Storm) {
          climates = Climate.thunder;
        } else if (firstWeather?.description == Description.Few_Cloud) {
          climates = Climate.cloudy;
        } else if (firstWeather?.description == Description.Sunny) {
          climates = Climate.sunny;
        } else {
          climates = Climate.unicorn;
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
      rethrow;
    }
  }

  Future<CityLocation> getCities({required String q}) async {
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
      var data = response.data as List<dynamic>;
      final first = data.first;
      final cities = Cities.fromJson(first);
      return CityLocation(
        name: cities.name,
        latitude: cities.lat,
        longitude: cities.lon,
      );
    } catch (error) {
      rethrow;
    }
  }
}
