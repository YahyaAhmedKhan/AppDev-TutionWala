import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/constants/image_paths.dart';
import 'package:tution_wala/models/tutor.dart';
import 'package:tution_wala/providers/tutors_provider.dart';
import 'package:tution_wala/widgets/tutor_card.dart';

class FilteredTutorListWidget extends ConsumerWidget {
  final double maxRate;
  final List<String> subjects;
  final String name;

  const FilteredTutorListWidget({
    Key? key,
    required this.maxRate,
    required this.subjects,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tutorsFutureAsyncValue = ref.watch(tutorsFutureProvider);

    return tutorsFutureAsyncValue.when(
      data: (querySnapshot) {
        final tutorDocs = querySnapshot.docs;

        final filteredTutors = tutorDocs
            .map((tutorDoc) => Tutor.fromFirestore(tutorDoc))
            .where((tutor) {
          // Filter tutors by max rate
          if (tutor.hourlyRate > maxRate) return false;

          // Filter tutors by first name
          final fullName = "${tutor.firstName} ${tutor.lastName}";
          if (!fullName.toLowerCase().contains(name.toLowerCase())) {
            return false;
          }
          // Filter tutors by subjects
          if (subjects.isNotEmpty &&
              !listContainsAll(tutor.subjects, subjects)) {
            return false;
          }

          return true;
        }).toList();

        return ListView.builder(
          itemCount: filteredTutors.length + 1,
          itemBuilder: (context, index) {
            if (index < filteredTutors.length) {
              final tutor = filteredTutors[index];
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

  // Custom function to check if all elements of one list are contained in another list
  bool listContainsAll(List<String> list, List<String> sublist) {
    for (var item in sublist) {
      if (!list.contains(item)) {
        return false;
      }
    }
    return true;
  }
}
