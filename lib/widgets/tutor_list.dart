import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/constants/image_paths.dart';
import 'package:tution_wala/helper/string_functions.dart';
import 'package:tution_wala/models/tutor.dart';
import 'package:tution_wala/pages/tutor_details_page.dart';
import 'package:tution_wala/providers/tutors_provider.dart';
import 'package:tution_wala/style/color_style.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:tution_wala/widgets/tutor_card.dart';

class TutorListWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutorsFutureAsyncValue = ref.watch(tutorsFutureProvider);

    return tutorsFutureAsyncValue.when(
      data: (querySnapshot) {
        final tutorDocs = querySnapshot.docs;

        return ListView.builder(
          itemCount: tutorDocs.length + 1,
          itemBuilder: (context, index) {
            if (index < tutorDocs.length) {
              final tutorDoc = tutorDocs[index];
              final tutorData = tutorDoc.data() as Map<String, dynamic>;
              final tutor = Tutor.fromFirestore(tutorDoc);
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: TutorCard(
                  tutor: tutor,
                  imageUrl: boyPics[Random().nextInt(4)],
                ),
              );
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * 0.5,
              );
            }
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
