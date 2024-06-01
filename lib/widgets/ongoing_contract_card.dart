import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tution_wala/helper/date_function.dart';
import 'package:tution_wala/helper/string_functions.dart';
import 'package:tution_wala/models/contract.dart';
import 'package:tution_wala/models/tutor.dart';
import 'package:tution_wala/providers/contracts_provider.dart';

class OngoingContractCard extends ConsumerWidget {
  final Contract contract;
  final Tutor tutor;
  final Function(String) handleTerminate;

  const OngoingContractCard({
    required this.contract,
    required this.tutor,
    required this.handleTerminate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(contract.id);
    return GestureDetector(
      onTap: () {
        // Navigate to contract detail page if needed
      },
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        child: Card(
          color: Colors.white,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
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
                                "${tutor.firstName} ${tutor.lastName}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                ' \$${tutor.hourlyRate.toStringAsFixed(2)}/hr',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            )
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
                IconButton(
                  onPressed: () {
                    // handleDelete(contract.id!);
                    showModalBottomSheet(
                      elevation: 0,
                      enableDrag: true,
                      isScrollControlled: true,
                      showDragHandle: true,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.70,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20)),
                          child: Expanded(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 186, 186),
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
                                          "Are you sure you want to terminate this contract?",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: const Color.fromARGB(
                                                    255,
                                                    239,
                                                    93,
                                                    83), // background color
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30), // curved corners
                                                ),
                                              ),
                                              onPressed: () {
                                                // handle continue button press

                                                handleTerminate(contract.id!);
                                                ref.refresh(
                                                    studentContractsProvider);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                "Continue",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: const Color.fromARGB(
                                                    255,
                                                    229,
                                                    229,
                                                    229), // background color
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                      width: 1,
                                                      color: Colors.black),
                                                  borderRadius:
                                                      BorderRadius.circular(
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
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons
                                                    .exclamationmark_circle_fill,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8),
                                                child: Text(
                                                  "This action cannot be undone.",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                  },
                  icon: const Icon(CupertinoIcons.clear_circled,
                      size: 30, color: Colors.red),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
