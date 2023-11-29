import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_report/models/day_weather.dart';

class ClimateItem extends StatelessWidget {
  const ClimateItem(this.dayClimates, {super.key});

  final DayClimate dayClimates;

  @override
  Widget build(BuildContext context) {
    final imageAsset = climateImages[dayClimates.climate];
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${DateFormat.d()}'),
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
                  dayClimates.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
