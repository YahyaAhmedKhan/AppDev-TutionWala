import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/providers/tutors_provider.dart';
import 'package:tution_wala/widgets/tutor_list.dart';

class TutorsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Find Tutors",
                        style: TextStyle(
                            fontSize: 34,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                      refreshButton()
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TutorListWidget(),
                )),
              ],
            ),
          ),
        ));
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
        ref.refresh(tutorsFutureProvider);
      },
      child: const Icon(
        Icons.refresh,
        size: 34,
      ),
    );
  }
}
