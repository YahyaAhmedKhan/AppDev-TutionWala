import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tution_wala/helper/date_function.dart';
import 'package:tution_wala/helper/string_functions.dart';
import 'package:tution_wala/models/contract.dart';
import 'package:tution_wala/models/student.dart';
import 'package:tution_wala/models/tutor.dart';
import 'package:tution_wala/providers/contracts_provider.dart';

class TutorPendingContractCard extends ConsumerWidget {
  final Contract contract;
  final Student student;
  final Function(String, WidgetRef) handleReject;
  final Function(String, WidgetRef) handleAccept;

  const TutorPendingContractCard({
    required this.contract,
    required this.student,
    required this.handleReject,
    required this.handleAccept,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(contract.id);
    return GestureDetector(
      onTap: () {
        // Navigate to contract detail page if needed
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Material(
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(20),
          elevation: 2,
          child: Card(
            color: Colors.transparent,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 70,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Icon(CupertinoIcons.calendar, size: 40),
                            const SizedBox(width: 10),
                            Text(
                              '${formatDateRange(contract.startDate, contract.endDate)}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )
                          ]),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "${student.firstName} ${student.lastName}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(children: [
                            Center(
                                child: Text(
                              'Offer made on: ${formatDateTime(contract.offerDate)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ))
                          ]),
                        ]),
                  ),
                  Expanded(
                    flex: 22,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            showAcceptMessagePrompt(context, ref);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 3, color: Colors.green)),
                            child: const Icon(Icons.check,
                                size: 30, color: Colors.green),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showRejectMessagePrompt(context, ref);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(width: 3, color: Colors.red)),
                            child: const Icon(Icons.close,
                                size: 30, color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showRejectMessagePrompt(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet(
      elevation: 0,
      enableDrag: true,
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.60,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20)),
          child: Expanded(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(30)),
                  // height:
                  // MediaQuery.of(context).size.height * 0.60,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Icon(
                            Icons.error_outline_sharp,
                            size: 50,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          "You're about to reject this contract",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(
                                    255, 239, 93, 83), // background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30), // curved corners
                                ),
                              ),
                              onPressed: () {
                                handleReject(contract.id!, ref);
                                ref.refresh(studentContractsProvider);
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Reject",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 214, 214, 214),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30), // curved corners
                                ),
                              ),
                              onPressed: () {
                                // handle continue button press
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.exclamationmark_circle_fill,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Text(
                                  "This action cannot be undone.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> showAcceptMessagePrompt(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet(
      elevation: 0,
      enableDrag: true,
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.60,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20)),
          child: Expanded(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(30)),
                  // height:
                  // MediaQuery.of(context).size.height * 0.60,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Icon(Icons.error_outline_sharp,
                              size: 50, color: Colors.black),
                        ),
                        const Text("You're about to accept this contract",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              onPressed: () {
                                handleAccept(contract.id!, ref);
                                ref.refresh(studentContractsProvider);
                                Navigator.of(context).pop();
                              },
                              child: const Text("Accept",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            )),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color.fromARGB(
                                      255, 229, 229, 229), // background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30), // curved corners
                                  ),
                                ),
                                onPressed: () {
                                  // handle continue button press
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "Go back",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                CupertinoIcons.calendar_badge_plus,
                                size: 30,
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    "The contract will begin from ${formatDate(contract.startDate)}",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
