import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/models/contract.dart';
import 'package:tution_wala/models/tutor.dart';
import 'package:tution_wala/providers/auth_state_notifier.dart';
import 'package:tution_wala/providers/contracts_provider.dart';
import 'package:tution_wala/providers/current_role_provider.dart';
import 'package:tution_wala/providers/tutor_weekly_schedule_provider.dart';
import 'package:tution_wala/service/firestore_service.dart';

class TutorWeeklySchedule extends ConsumerWidget {
  const TutorWeeklySchedule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WeeklyScheduleWidget();
  }
}

class WeeklyScheduleWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Retrieve the weekly schedule from the provider
    final weeklySchedule = ref.read(tutorWeeklyScheduleProvider);
    print(weeklySchedule);

    print(weeklySchedule);

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

    return ListView.builder(
      itemCount: daysOfWeek.length,
      itemBuilder: (context, index) {
        final day = daysOfWeek[index];

        // Retrieve the contract IDs for the current day
        final contractIds = weeklySchedule?[day] ?? [];

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
                  children: contractIds.map((id) => Text(id)).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
