import 'package:flutter/material.dart';
import 'package:weather_report/components/api_service.dart';
import 'package:weather_report/components/location_service.dart';
import 'package:weather_report/components/horizontal_card.dart';
import 'package:weather_report/components/vertical_card.dart';
import 'package:weather_report/models/daily_weather.dart';
import 'package:weather_report/models/day_weather.dart';
import 'package:weather_report/models/time_weather.dart';

class ShowWeather extends StatefulWidget {
  const ShowWeather({super.key});

  @override
  State<ShowWeather> createState() => _ShowWeatherState();
}

class _ShowWeatherState extends State<ShowWeather> {
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();

  ThisWeather? thisWeather;
  DailyWeather? dailyWeather;
  bool isCelsius = true;
  DayWeather? dayWeather;

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
    print('weathers $weathers');
    setState(() {
      dailyWeather = weathers;
    });
  }

  Future<void> _getWeather() async{
    final position = await _locationService.getCurrentLocation();
    final weathers = await _apiService.getForecastWeather(
      latitude: position.latitude,
      longitude: position.longitude,
    );
    print('weathers $weathers');
    setState(() {
      thisWeather = weathers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final city = thisWeather?.city.toUpperCase();
    final highTempInCelsius = dailyWeather?.highTempInCelsius;
    final highTempInFahrenheit = dailyWeather?.highTemperatureFahrenheit;
    final String displayedHighTemp;
    if (dailyWeather != null) {
      displayedHighTemp = isCelsius
          ? highTempInCelsius.toString()
          : highTempInFahrenheit.toString();
    } else {
      displayedHighTemp = '??';
    }
    final lowTempInCelsius = dailyWeather?.lowTempInCelsius;
    final lowTempInFahrenheit = dailyWeather?.lowTemperatureFahrenheit;
    final String displayedLowTemp;
    if (dailyWeather != null) {
      displayedLowTemp = isCelsius
          ? lowTempInCelsius.toString()
          : lowTempInFahrenheit.toString();
    } else {
      displayedLowTemp = '??';
    }
    final nowTempInCelsius = dailyWeather?.temperatureInCelsius;
    final nowTempInFahrenheit = dailyWeather?.temperatureFahrenheit;
    final String displayedTemperature;
    final nowHumidity = dailyWeather?.humidity.toString();
    if (dailyWeather != null) {
      displayedTemperature = isCelsius
          ? nowTempInCelsius.toString()
          : nowTempInFahrenheit.toString();
    } else {
      displayedTemperature = '??';
    }

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
                height: 80,
              ),
              //Search City Bar
              const SizedBox(
                width: 380,
                child: SearchBar(),
              ),

              const SizedBox(
                height: 16,
              ),

              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    '$city',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Image.asset(
                            'assets/images/sunny.png',
                            width: 125,
                            height: 125,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 50,
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 100,
                            ),
                            children: [
                              TextSpan(
                                text: '$displayedTemperature°',
                              ),
                              TextSpan(
                                text: isCelsius ? ' C' : ' F',
                                style: const TextStyle(
                                  fontSize: 25,
                                ), // Font size for the decimal part
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 65,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isCelsius = true;
                                  });
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(32),
                                        topRight: Radius.circular(32),
                                      ),
                                      side: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    const Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                                child: const Text(
                                  '°C',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black,),
                                ),
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 65,
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isCelsius = false;
                                    });
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(32),
                                          bottomRight: Radius.circular(32),
                                        ),
                                        side: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      const Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                  child: const Text(
                                    '°F',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        'H :   $displayedHighTemp',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        'L :   $displayedLowTemp',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              Container(
                height: 65,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color.fromARGB(82, 255, 255, 255),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(Icons.water_drop_outlined),
                    Text(
                      '   HUMIDITY             $nowHumidity %',
                      style:
                          const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
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
