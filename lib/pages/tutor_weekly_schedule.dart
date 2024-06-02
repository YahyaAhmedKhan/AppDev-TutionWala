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
        return Container(
          child: ListView.builder(
            // shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            itemCount: daysOfWeek.length,
            itemBuilder: (context, index) {
              final day = daysOfWeek[index];

              // Retrieve the students for the current day
              final students = weeklySchedule[day.toLowerCase()] ?? [];
              print("students: $students");

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Label part (day of the week)
                    Expanded(
                      flex: 30,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          day,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    // Names part (student names)
                    Expanded(
                      flex: 70,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: students
                                .map((student) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 12.0),
                                        decoration: BoxDecoration(
                                          color: Colors.lightBlue.shade50,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color: Colors.lightBlue.shade100,
                                          ),
                                        ),
                                        child: Text(
                                          "${student.firstName} ${student.lastName}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        return Center(child: Text('Error: ${error.toString()}'));
        throw error;
      },
    );
  }
}
