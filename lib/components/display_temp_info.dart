import 'package:flutter/material.dart';

import '../models/climate.dart';
import '../models/daily_weather.dart';
import '../models/day_climate.dart';
import '../models/time_weather.dart';

class DisplayTempInfo extends StatelessWidget {
  const DisplayTempInfo({
    super.key,
    required this.onChangeDegreeUnit,
    required this.dailyWeather,
    required this.dayClimate,
    required this.dayWeather,
    required this.thisWeather,
    required this.isCelsius,
  });

  final ThisWeather? thisWeather;
  final DailyWeather? dailyWeather;
  final DayClimate? dayClimate;
  final DayWeather? dayWeather;
  final void Function(bool isCelsius) onChangeDegreeUnit;
  final bool isCelsius;

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

    final imageOfClimate = dailyWeather?.climate;
    final imageClimate = climateImages[imageOfClimate];

    return Column(
      children: [
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
                    imageClimate != null
                        ? Image.asset(
                            imageClimate,
                            width: 125,
                            height: 125,
                          )
                        : const SizedBox(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 65,
                      child: ElevatedButton(
                        onPressed: () {
                          onChangeDegreeUnit(true);
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        child: const Text(
                          '°C',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 65,
                      child: ElevatedButton(
                          onPressed: () {
                            onChangeDegreeUnit(false);
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
                            backgroundColor: MaterialStateProperty.all<Color>(
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
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                'H :   $displayedHighTemp',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(
                'L :   $displayedLowTemp',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
            color: const Color.fromARGB(82, 255, 255, 255),
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
      ],
    );
  }
}
