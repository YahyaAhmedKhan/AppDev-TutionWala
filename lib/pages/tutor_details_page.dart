import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tution_wala/helper/string_functions.dart';
import 'package:tution_wala/models/tutor.dart';
import 'package:tution_wala/style/color_style.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tution_wala/widgets/contract_prompt_sheet.dart';

class TutorDetailPage extends StatefulWidget {
  // final String? firstName;
  // final String? lastName;
  // final double? hourlyRate;
  final String imageUrl;
  // final List<String> subjects;
  // final List<String> days;
  // final double? rating;
  // final String id;
  final Tutor tutor;

  TutorDetailPage({
    // required this.firstName,
    // required this.lastName,
    // required this.hourlyRate,
    required this.imageUrl,
    // required this.subjects,
    // required this.days,
    // required this.id,
    // required this.rating,
    required this.tutor,
  });

  @override
  State<TutorDetailPage> createState() => _TutorDetailPageState();
}

class _TutorDetailPageState extends State<TutorDetailPage> {
  @override
  bool showFullDesc = false;
  Widget build(BuildContext context) {
    void toggleShowDesc() {
      setState(() {
        showFullDesc = !showFullDesc;
        print(showFullDesc);
      });
    }

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(50),
        child: GestureDetector(
          onTap: () {
            print("Pressed Hire");
            showModalBottomSheet(
              elevation: 0,
              enableDrag: true,
              isScrollControlled: true,
              showDragHandle: true,
              backgroundColor: const Color.fromARGB(255, 228, 228, 228),
              context: context,
              builder: (context) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ContractPrompt(
                    tutorRef: widget.tutor.id!,
                  )),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 72, 200, 78),
                borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hire ${widget.tutor.firstName}",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const FaIcon(
                    FontAwesomeIcons.arrowRight,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: ColorStyles.primaryGreen,
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "${widget.tutor.firstName} ${widget.tutor.lastName}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: widget.tutor.id!,
                    child: Image.asset(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black
                              .withOpacity(0.6), // Adjust the opacity as needed
                        ],
                        stops: const [
                          0.6,
                          1.0
                        ], // Adjust the gradient stops as needed
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.tutor.firstName} ${widget.tutor.lastName}",
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              "${widget.tutor.rating ?? '-'}/5.0",
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w700),
                            ),
                            const Icon(
                              Icons.star_rounded,
                              size: 30,
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\$${widget.tutor.hourlyRate!.toStringAsFixed(2)}/hr",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Subjects:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: widget.tutor.subjects
                          .map((subject) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: ColorStyles
                                                .subjectColors[subject] ??
                                            Colors.white,
                                        border: Border.all(width: 1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      child: Text(
                                          capFirstLetter(
                                            subject,
                                          ),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    )),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Availability:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: widget.tutor.days
                          .map((day) => Chip(label: Text(capFirstLetter(day))))
                          .toList(),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 6, bottom: 6),
                      child: Text("About:",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w700)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Wrap(
                        children: [
                          Text(
                              widget.tutor.description ??
                                  "No description available",
                              maxLines: showFullDesc ? null : 5,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: toggleShowDesc,
                            child:
                                Text(!showFullDesc ? "Show more" : "Show Less"))
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
