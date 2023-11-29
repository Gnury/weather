import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
    final nextDayClimates = weathers
        ?.whereNot(
          (e) =>
              e.dateTime.year == now.year &&
              e.dateTime.month == now.month &&
              e.dateTime.day == now.day,
        )
        .map(
          (e) {
            return DayClimate(
            climate: e.climate,
            title: e.title.toString(),
            date: e.dateTime,
          );
          },
        )
        .toList().sublist(1,5);

    final content = nextDayClimates == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: nextDayClimates.length,
            itemBuilder: (ctx, index) {
              final item = nextDayClimates[index];
              final imageAsset = climateImages[item.climate];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(80, 255, 255, 255),
                    ),
                    width: 200,
                    height: 100,
                    child: Column(
                      children: [
                        Text('${item.date}'),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
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

              // ClimateItem(
              //   dayClimates![index],
              // ),
            },
          );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(170, 68, 112, 255),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 400,
      child: content,
    );
  }
}
