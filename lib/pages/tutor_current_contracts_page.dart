import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/pages/tutor_current_contracts_list.dart';
import 'package:tution_wala/providers/contracts_provider.dart';
import 'package:tution_wala/providers/tutor_weekly_schedule_provider.dart';

class TutorCurrentContractsPage extends StatelessWidget {
  TutorCurrentContractsPage({super.key});

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
                        "Active Contracts",
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
                  child: TutorCurrentContractsList(),
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
        ref.refresh(tutorContractsProvider);
      },
      child: const Icon(
        Icons.refresh,
        size: 34,
      ),
    );
  }
}
