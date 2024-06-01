import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/constants/image_paths.dart';
import 'package:tution_wala/helper/string_functions.dart';
import 'package:tution_wala/models/tutor.dart';
import 'package:tution_wala/pages/tutor_details_page.dart';
import 'package:tution_wala/providers/tutors_provder.dart';
import 'package:tution_wala/style/color_style.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:tution_wala/widgets/tutor_card.dart';

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
                itemCount: tutorDocs.length,
                itemBuilder: (context, index) {
                  final tutorDoc = tutorDocs[index];
                  final tutorData = tutorDoc.data() as Map<String, dynamic>;
                  final tutor = Tutor.fromFirestore(tutorDoc);
                  print(tutorData['selectedDays']);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TutorCard(
                      tutor: tutor,
                      // id: tutorDoc.id,
                      // firstName: tutorData['firstName'],
                      // lastName: tutorData['lastName'],
                      // hourlyRate: tutorData['hourlyRate'],
                      // experience: tutorData['experience'],
                      // expertise: tutorData['expertise'],
                      imageUrl: boyPics[Random().nextInt(4)],
                      // subjects: (tutorData['subjects'] as List<dynamic>)
                      //     .map((subject) => subject as String)
                      //     .toList(),
                      // days: (tutorData['selectedDays'] as List<dynamic>)
                      //     .map((day) => day as String)
                      //     .toList(),
                      // rating: tutorData['rating'],
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
