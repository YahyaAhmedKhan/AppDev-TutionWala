import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/constants/image_paths.dart';
import 'package:tution_wala/helper/string_functions.dart';
import 'package:tution_wala/pages/tutor_details_page.dart';
import 'package:tution_wala/providers/tutors_provder.dart';
import 'package:tution_wala/style/color_style.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class TutorListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutorsStreamAsyncValue = ref.watch(tutorsStreamProvider);

    return tutorsStreamAsyncValue.when(
      data: (stream) {
        return StreamBuilder<QuerySnapshot>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final tutorDocs = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
              child: ListView.builder(
                itemCount: tutorDocs.length * 10,
                itemBuilder: (context, index) {
                  final tutorDoc = tutorDocs[index ~/ 10];
                  final tutorData = tutorDoc.data() as Map<String, dynamic>;
                  print(tutorData['selectedDays']);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TutorCard(
                      id: "${tutorDoc.id}-$index",
                      firstName: tutorData['firstName'],
                      lastName: tutorData['lastName'],
                      hourlyRate: tutorData['hourlyRate'],
                      experience: tutorData['experience'],
                      expertise: tutorData['expertise'],
                      imageUrl: boyPics[Random().nextInt(4)],
                      subjects: (tutorData['subjects'] as List<dynamic>)
                          .map((subject) => subject as String)
                          .toList(),
                      days: (tutorData['selectedDays'] as List<dynamic>)
                          .map((day) => day as String)
                          .toList(),
                      rating: tutorData['rating'],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}

class TutorCard extends StatelessWidget {
  final String? firstName;
  final String? lastName;
  final double? hourlyRate;
  final String id;
  final String? expertise;
  final double? experience;
  final String? imageUrl;
  final List<String> subjects;
  final List<String> days;
  final double? rating;

  const TutorCard(
      {required this.firstName,
      required this.lastName,
      required this.hourlyRate,
      required this.imageUrl,
      required this.experience,
      required this.expertise,
      required this.id,
      required this.subjects,
      required this.days,
      required this.rating});

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
    final availableIndices = days.map((day) => dayIndices[day]).toList();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TutorDetailPage(
              firstName: firstName,
              lastName: lastName,
              hourlyRate: hourlyRate,
              imageUrl: imageUrl!,
              subjects: subjects,
              days: days,
              rating: rating,
              id: id!,
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
                              Text(
                                "${firstName ?? ''} ${lastName ?? ''} ",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
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
                                            "${rating != null ? "$rating/5" : "No rating"}",
                                            style: TextStyle(
                                                fontWeight: rating != null
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
                              '\$${hourlyRate?.toStringAsFixed(2) ?? 'null'}/hr',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          // Add more fields or actions if needed
                        ],
                      ),
                    ),
                    Hero(
                      transitionOnUserGestures: true,
                      tag: id,
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
                  children: subjects
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
