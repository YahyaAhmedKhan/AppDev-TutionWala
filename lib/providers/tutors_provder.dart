import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tution_wala/models/tutor.dart';
import 'package:tution_wala/service/firestore_service.dart';

final tutorsStreamProvider = FutureProvider<Stream<QuerySnapshot>>((ref) async {
  return FirestoreService().getTutors();
});

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
              return Center(child: CircularProgressIndicator());
            }

            final tutorDocs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: tutorDocs.length * 10,
              itemBuilder: (context, index) {
                final tutorDoc = tutorDocs[index ~/ 10];
                final tutorData = tutorDoc.data() as Map<String, dynamic>;
                return TutorCard(
                  firstName: tutorData['firstName'],
                  lastName: tutorData['lastName'],
                  hourlyRate: tutorData['hourlyRate'],
                  // Add more fields as needed
                );
              },
            );
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}

class TutorCard extends StatelessWidget {
  final String? firstName;
  final String? lastName;
  final double? hourlyRate;

  const TutorCard({
    required this.firstName,
    required this.lastName,
    required this.hourlyRate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        title: Text("${firstName ?? '-'} ${lastName ?? '-'} "),
        subtitle:
            Text('Hourly Rate: \$${hourlyRate?.toStringAsFixed(2) ?? 'null'}'),
        // Add more fields or actions if needed
      ),
    );
  }
}
