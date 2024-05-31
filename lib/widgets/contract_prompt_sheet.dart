import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:async_button_builder/async_button_builder.dart';
import 'package:tution_wala/models/contract.dart';
import 'package:tution_wala/providers/auth_state_notifier.dart';
import 'package:tution_wala/service/firestore_service.dart';
import 'package:tution_wala/style/color_style.dart';

class ContractPrompt extends ConsumerStatefulWidget {
  final String tutorRef;
  const ContractPrompt({
    super.key,
    required this.tutorRef,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContractPromptState();
}

class _ContractPromptState extends ConsumerState<ContractPrompt> {
  DateTimeRange range = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(const Duration(days: 7)));

  // final today = DateTime.now();
  // final oneWeekFromToday = DateTime.now().add(const Duration(days: 7));

  Future<void> handleHire() async {
    final contract = Contract(
      days: range.duration.inDays,
      endDate: range.end,
      startDate: range.start,
      state: 'pending',
      studentRef: ref.read(authStateProvider).account!.studentRef!,
      tutorRef: widget.tutorRef,
    );
    print(contract.studentRef);
    print(contract.tutorRef);

    final FirestoreService firestoreService = FirestoreService();

    await Future.delayed(Duration(seconds: 2));
    // throw Exception("testing");

    final docRef = firestoreService.addContract(contract);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      builder: (context, scrollController) => Material(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        elevation: 2,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Text(
                  'Hiring Tutor',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Center(
                        child: Text(
                            "Select the start and end dates for your contract",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      indent: 40,
                      endIndent: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: RangeDatePicker(
                        currentDateTextStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 20),
                        singleSelectedCellDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                            border: Border.all(
                              width: 1,
                            )),
                        currentDateDecoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1,
                            )),
                        singleSelectedCellTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                        leadingDateTextStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        enabledCellsTextStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 20),
                        selectedCellsTextStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                        splashColor: Colors.transparent,
                        padding: const EdgeInsets.all(0),
                        selectedRange: range,
                        splashRadius: 0,
                        onRangeSelected: (value) {
                          setState(() {
                            range = value;
                          });
                          print(range);
                        },
                        slidersColor: Colors.black,
                        highlightColor: Colors.black,
                        centerLeadingDate: true,
                        minDate: DateTime.now(),
                        maxDate: DateTime.now().add(const Duration(days: 365)),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                indent: 40,
                endIndent: 40,
              ),
              const SizedBox(
                height: 5,
              ),
              HireButton(
                handleHire: () async {
                  await handleHire();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Booking made successfilly")));
                },
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HireButton extends StatefulWidget {
  final Function() handleHire;
  const HireButton({
    super.key,
    required this.handleHire,
  });

  @override
  State<HireButton> createState() => _HireButtonState();
}

class _HireButtonState extends State<HireButton> {
  @override
  Widget build(BuildContext context) {
    return AsyncButtonBuilder(
      loadingWidget: Container(
        decoration: BoxDecoration(
            color: ColorStyles.primaryGreen,
            borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * .5,
            child: Center(
              child: Transform.scale(
                scale: 0.5,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            )),
      ),
      errorWidget: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 106, 96),
            borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * .5,
            child: const Center(
                child: Text(
              "Error!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ))),
      ),
      successWidget: Container(
        decoration: BoxDecoration(
            color: Colors.greenAccent.shade400,
            borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * .5,
            child: const Center(
                child: Text(
              "Success!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ))),
      ),
      onPressed: () async {
        // await Future.delayed(const Duration(seconds: 2));
        await widget.handleHire();
        // throw Exception("hehe");
      },
      builder: (context, child, callback, state) {
        return Material(
          color: state.maybeWhen(
            success: () => Colors.purple[100],
            orElse: () => Colors.blue,
          ),
          // This prevents the loading indicator showing below the
          // button
          // clipBehavior: Clip.hardEdge,

          clipBehavior: Clip.hardEdge,
          // borderRadius: BorderRadius.circular(50),
          shape: const StadiumBorder(),
          child: InkWell(
            child: child,
            onTap: callback,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: ColorStyles.primaryGreen,
            borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width * .5,
            child: const Center(
                child: Text(
              "Hire",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ))),
      ),
    );
  }
}
