import 'package:dio/dio.dart';
import 'package:weather_report/components/cities.dart';
import 'package:weather_report/components/response_forecast_weather.dart';
import 'package:weather_report/components/response_weather.dart';
import 'package:weather_report/models/daily_weather.dart';
import 'package:weather_report/models/day_weather.dart';
import 'package:weather_report/models/time_weather.dart';
import 'package:weather_report/models/city_name.dart';

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

      final temperatureInFahrenheit = weather.main.temp;
      final temperatureInCelsius = (temperatureInFahrenheit - 32) / 5 ~/ 9;
      final humidityNow = weather.main.humidity;
      final highTempInFahrenheit = weather.main.tempMax;
      final highTempInCelsius = (highTempInFahrenheit - 32) / 5 ~/ 9;
      final lowTempInFahrenheit = weather.main.tempMin;
      final lowTempInCelsius = (lowTempInFahrenheit - 32) / 5 ~/ 9;
      return DailyWeather(
        temperatureInCelsius: temperatureInCelsius,
        dateTime: DateTime.now(),
        humidity: humidityNow,
        highTempInCelsius: highTempInCelsius,
        lowTempInCelsius: lowTempInCelsius,
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
        final temperatureInFahrenheit = weather.main.temp;
        final temperatureInCelsius = (temperatureInFahrenheit - 32) / 5 ~/ 9;
        final firstWeather = weather.weather.firstOrNull;
        final description = firstWeather?.description?.name;


        final Climate? climates;
        if(firstWeather?.main == null){
          climates = Climate.sunny;
        }else if(firstWeather?.main == MainEnum.CLOUDS){
          climates = Climate.cloudy;
        }else if(firstWeather?.main == MainEnum.RAIN){
          climates = Climate.dayRainy;
        }else{
          climates = null;
        }
        return TimeWeather(
          temperatureInCelsius: temperatureInCelsius,
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
