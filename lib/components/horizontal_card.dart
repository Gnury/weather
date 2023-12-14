import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_report/models/time_weather.dart';

import '../models/climate.dart';

class HorizontalCard extends StatelessWidget {
  final List<TimeWeather>? weathers;
  final bool isCelsius;

  const HorizontalCard({
    super.key,
    required this.weathers,
    required this.isCelsius,
  });

  @override
  Widget build(BuildContext context) {
    final weathers = this.weathers;
    final now = DateTime.now();
    final todayWeathers = weathers
        ?.where((e) =>
            e.dateTime.year == now.year &&
            e.dateTime.month == now.month &&
            e.dateTime.day == now.day)
        .toList();
    final List<TimeWeather>? nowAndNextTwentyFourHoursWeathers =
        todayWeathers != null
            ? todayWeathers.isNotEmpty
                ? todayWeathers
                : []
            : null;

    final content = nowAndNextTwentyFourHoursWeathers == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: nowAndNextTwentyFourHoursWeathers.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final item = nowAndNextTwentyFourHoursWeathers[index];
              final tempCelsius = item.temperatureInCelsius.toString();
              final tempFahrenheit = item.temperatureFahrenheit.toString();
              final String displayedTemperature = isCelsius
                  ? tempCelsius.toString()
                  : tempFahrenheit.toString();
              final imageAsset = climateImages[item.climate];
              final timeLabel = DateFormat('HH:mm').format(item.dateTime);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(80, 255, 255, 255),
                  ),
                  width: 110,
                  child: Column(
                    children: [
                      imageAsset != null
                          ? Image.asset(
                              imageAsset,
                              width: 75,
                              height: 75,
                            )
                          : const SizedBox(
                              width: 75,
                              height: 75,
                            ),
                      Text(timeLabel),
                      Text('$displayedTemperature°'),
                    ],
                  ),
                ),
              );
            },
          );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(170, 68, 112, 255),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 160,
      child: content,
    );
  }
}
