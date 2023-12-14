import 'package:flutter/material.dart';
import 'package:weather_report/components/api_service.dart';
import 'package:weather_report/components/display_temp_info.dart';
import 'package:weather_report/components/location_service.dart';
import 'package:weather_report/components/horizontal_card.dart';
import 'package:weather_report/components/vertical_card.dart';
import 'package:weather_report/models/city_name.dart';
import 'package:weather_report/models/daily_weather.dart';
import 'package:weather_report/models/day_climate.dart';
import 'package:weather_report/models/time_weather.dart';
import 'package:weather_report/pages/city_weather.dart';

class ShowWeather extends StatefulWidget {
  const ShowWeather({super.key});

  @override
  State<ShowWeather> createState() => _ShowWeatherState();
}

class _ShowWeatherState extends State<ShowWeather> {
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();

  final TextEditingController _searchFieldController = TextEditingController();

  ThisWeather? thisWeather;
  DailyWeather? dailyWeather;
  DayClimate? dayClimate;
  bool isCelsius = true;
  DayWeather? dayWeather;
  CityLocation? cityLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentWeather();
    _getWeather();
  }

  Future<void> _getCurrentWeather() async {
    final position = await _locationService.getCurrentLocation();
    final weathers = await _apiService.getCurrentWeather(
      latitude: position.latitude,
      longitude: position.longitude,
    );
    setState(() {
      dailyWeather = weathers;
    });
  }

  Future<void> _getWeather() async {
    final position = await _locationService.getCurrentLocation();
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
      // appBar: AppBar(),

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
                height: 40,
              ),
              //Search City Bar
              SizedBox(
                width: 380,
                child: SearchBar(
                  controller: _searchFieldController,
                  hintText: 'Search City...',
                  leading: const Icon(Icons.search),
                  onSubmitted: (query) {
                    // final query = _searchFieldController.value.text;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowCityWeather(query: query),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 16,
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

              const SizedBox(
                height: 20,
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
