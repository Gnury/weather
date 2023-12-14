import 'package:flutter/material.dart';
import 'package:weather_report/components/api_service.dart';
import 'package:weather_report/components/display_temp_info.dart';
import 'package:weather_report/components/horizontal_card.dart';
import 'package:weather_report/components/vertical_card.dart';
import 'package:weather_report/models/city_name.dart';
import 'package:weather_report/models/daily_weather.dart';
import 'package:weather_report/models/day_climate.dart';
import 'package:weather_report/models/time_weather.dart';
import 'package:weather_report/pages/show_weather.dart';


class ShowCityWeather extends StatefulWidget {
  final String query;
  const ShowCityWeather({super.key, required this.query});

  @override
  State<ShowCityWeather> createState() => _ShowCityWeatherState();
}

class _ShowCityWeatherState extends State<ShowCityWeather> {
  final ApiService _apiService = ApiService();

  ThisWeather? thisWeather;
  DailyWeather? dailyWeather;
  DayClimate? dayClimate;
  bool isCelsius = true;
  DayWeather? dayWeather;
  CityLocation? cityName;

  @override
  void initState() {
    super.initState();
    _getLocation(widget.query);
  }

  Future<void> _getLocation(String query) async {
    final position = await _apiService.getCities(q: query);
    _getCurrentWeather(position);
    _getWeather(position);
  }

  Future<void> _getCurrentWeather(CityLocation position) async {
      final weathers = await _apiService.getCurrentWeather(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      setState(() {
        dailyWeather = weathers;
      });
  }

  Future<void> _getWeather(CityLocation position) async {
      final weathers = await _apiService.getForecastWeather(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      setState(() {
        thisWeather = weathers;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 0, 112, 204),
                Color.fromARGB(255, 165, 198, 255),
              ]),
        ),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShowWeather(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const SizedBox(
                height: 20,
              ),
              DisplayTempInfo(
                onChangeDegreeUnit: (isCelsius) {
                  setState(() {
                    this.isCelsius = isCelsius;
                  });
                },
                dailyWeather: dailyWeather,
                dayClimate: dayClimate,
                dayWeather: dayWeather,
                thisWeather: thisWeather,
                isCelsius: isCelsius,
              ),
              HorizontalCard(
                weathers: thisWeather?.list,
                isCelsius: isCelsius,
              ),
              const SizedBox(
                height: 25,
              ),
              VerticalCard(
                weathers: thisWeather?.list,
                dayClimates: dayWeather?.dayClimates,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
