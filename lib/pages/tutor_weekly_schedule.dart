import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/providers/tutor_weekly_schedule_provider.dart';

class WeeklyScheduleWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Retrieve the weekly schedule from the provider
    final weeklyScheduleAsyncValue = ref.watch(weeklyScheduleProvider);

    // Define the days of the week
    final daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return weeklyScheduleAsyncValue.when(
      data: (weeklySchedule) {
        return ListView.builder(
          itemCount: daysOfWeek.length,
          itemBuilder: (context, index) {
            final day = daysOfWeek[index];

            // Retrieve the contract IDs for the current day
            final students = weeklySchedule[day.toLowerCase()] ?? [];

            return Row(
              children: [
                // Label part (day of the week)
                Expanded(
                  flex: 30,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(day),
                  ),
                ),
                // IDs part (contract IDs)
                Expanded(
                  flex: 70,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: students
                          .map((student) => Text(student.firstName))
                          .toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Error: ${error.toString()}')),
    );
  }
}
