import 'package:flutter/material.dart';
import 'package:tution_wala/helper/string_functions.dart';
import 'package:tution_wala/models/tutor.dart';
import 'package:tution_wala/pages/tutor_details_page.dart';
import 'package:tution_wala/style/color_style.dart';

class TutorCard extends StatelessWidget {
  // final String? firstName;
  // final String? lastName;
  // final double? hourlyRate;
  // final String id;
  // final String? expertise;
  // final double? experience;
  final String? imageUrl;
  // final List<String> subjects;
  // final List<String> days;
  // final double? rating;
  final Tutor tutor;

  const TutorCard({
    // required this.firstName,
    // required this.lastName,
    // required this.hourlyRate,
    required this.imageUrl,
    // required this.experience,
    // required this.expertise,
    // required this.id,
    // required this.subjects,
    // required this.days,
    // required this.rating,
    required this.tutor,
  });

  @override
  Widget build(BuildContext context) {
    // Map full day names to their indices
    final dayIndices = {
      'monday': 0,
      'tuesday': 1,
      'wednesday': 2,
      'thursday': 3,
      'friday': 4,
      'saturday': 5,
      'sunday': 6,
    };

    // Full week for display
    final weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    // Get indices for available days
    final availableIndices = tutor.days.map((day) => dayIndices[day]).toList();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutorDetailPage(
              // firstName: tutor.firstName,
              // lastName: tutor.lastName,
              // hourlyRate: tutor.hourlyRate,
              imageUrl: imageUrl!,
              // subjects: tutor.subjects,
              // days: tutor.days,
              // rating: tutor.rating,
              // id: tutor.id!,
              tutor: tutor,
            ),
          ),
        );
      },
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        child: Card(
          color: Colors.white,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${tutor.firstName ?? ''} ${tutor.lastName ?? ''} ",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 4, right: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 00),
                                          child: Text(
                                            "${tutor.rating != null ? "${tutor.rating}/5" : "No rating"}",
                                            style: TextStyle(
                                                fontWeight: tutor.rating != null
                                                    ? FontWeight.w700
                                                    : FontWeight.w600,
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.star_rounded,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                              '\$${tutor.hourlyRate?.toStringAsFixed(2) ?? 'null'}/hr',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          // Add more fields or actions if needed
                        ],
                      ),
                    ),
                    Hero(
                      transitionOnUserGestures: true,
                      tag: tutor.id!,
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: imageUrl != null
                              ? Image.asset(
                                  imageUrl!,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.person, size: 50),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  children: tutor.subjects
                      .map((subject) => Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    color: ColorStyles.subjectColors[subject],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  child: Text(capFirstLetter(subject),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600)),
                                )),
                          ))
                      .toList(),
                ),
                // const SizedBox(height: 10),
                const Text(
                  'Availability:',
                  style: TextStyle(
                      color: Color.fromARGB(255, 127, 127, 127),
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: weekDays.asMap().entries.map((entry) {
                    final index = entry.key;
                    final initial = entry.value;
                    final isAvailable = availableIndices.contains(index);

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Material(
                        elevation: isAvailable ? 3 : 0,
                        shape: const CircleBorder(),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 1,
                                color: isAvailable
                                    ? Colors.transparent
                                    : Colors.black),
                            // borderRadius: BorderRadius.circular(0),
                            color: isAvailable
                                ? Colors.blue
                                : const Color.fromARGB(255, 233, 233, 233),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Text(
                              initial,
                              style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      isAvailable ? Colors.white : Colors.black,
                                  fontWeight: isAvailable
                                      ? FontWeight.w700
                                      : FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
