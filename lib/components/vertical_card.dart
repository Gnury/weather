import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_report/models/day_weather.dart';

import '../models/time_weather.dart';

class VerticalCard extends StatelessWidget {
  final List<DayClimate>? dayClimates;
  final List<TimeWeather>? weathers;

  const VerticalCard({
    super.key,
    required this.dayClimates,
    required this.weathers,
  });

  @override
  Widget build(BuildContext context) {
    final weathers = this.weathers;
    final now = DateTime.now();

    List<TimeWeather>? filteredWeathers;
    if (weathers != null) {
      filteredWeathers = [];
      for (TimeWeather e in weathers) {
        final isToday = e.dateTime.year == now.year &&
            e.dateTime.month == now.month &&
            e.dateTime.day == now.day;
        if (!isToday) {
          filteredWeathers.add(e);
        }
      }
    }

    List<DayClimate>? showFilteredWeathers;
    if (filteredWeathers != null) {
      showFilteredWeathers = [];
      for (TimeWeather e in filteredWeathers) {
        final dayClimate = DayClimate(
          climate: e.climate,
          title: e.title.toString(),
          date: e.dateTime,
        );
        showFilteredWeathers.add(dayClimate);
      }
    }

    // yyyy-MM-dd
    Map<String, List<DayClimate>>? groupOfClimate;
    // yyyy-MM-dd HH:mm:ss.SSSS
    if (showFilteredWeathers != null) {
      groupOfClimate = {};
      for (DayClimate e in showFilteredWeathers) {
        final dateTime = e.date;
        final dateTimeSplit = dateTime.toString().split(' ');
        final key = dateTimeSplit[0];
        List<DayClimate>? listOfDayClimates = groupOfClimate[key];
        if (listOfDayClimates == null) {
          listOfDayClimates = [];
        }
        groupOfClimate[key] = listOfDayClimates + [e];
      }
    }

    List<DayClimate>? firstClimateOfTheDay;
    if (groupOfClimate != null) {
      firstClimateOfTheDay = [];
      final listOfDayClimateList = groupOfClimate.values;
      for (List<DayClimate> e in listOfDayClimateList) {
        firstClimateOfTheDay.add(e[0]);
      }
    }

    final content = firstClimateOfTheDay == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: firstClimateOfTheDay.length,
            itemBuilder: (ctx, index) {
              final item = firstClimateOfTheDay![index];
              final imageAsset = climateImages[item.climate];
              final dateLabel = DateFormat('EEEE').format(item.date);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(80, 255, 255, 255),
                    ),
                    width: 200,
                    height: 50,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(dateLabel),
                            const SizedBox(
                              width: 20,
                            ),
                            imageAsset != null
                                ? Image.asset(
                                    imageAsset,
                                    width: 50,
                                    height: 50,
                                  )
                                : const SizedBox(),
                            const Spacer(),
                            Text(
                              item.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ],
                    ),
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
      height: 250,
      child: content,
    );
  }
}
