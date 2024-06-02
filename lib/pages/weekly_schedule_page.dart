import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/pages/tutor_weekly_schedule.dart';
import 'package:tution_wala/providers/tutor_weekly_schedule_provider.dart';

class WeeklySchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Material(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(
                    16), // adjust the radius value to your liking
                bottom: Radius.circular(
                    16), // adjust the radius value to your liking
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 20, top: 20),
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.calendar_today,
                          size: 34,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            "Weekly Schedule ",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              // color: Colors.white
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: refreshButton(),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: WeeklyScheduleWidget(),
                  ))
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        const Expanded(
          child: Center(),
        ),
      ],
    );
  }
}

class refreshButton extends ConsumerWidget {
  const refreshButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        print("hi");
        ref.refresh(weeklyScheduleProvider);
      },
      child: const Icon(
        Icons.refresh,
        size: 34,
      ),
    );
  }
}
