import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/models/contract.dart';
import 'package:tution_wala/models/student.dart';
import 'package:tution_wala/models/tutor.dart';
import 'package:tution_wala/pages/tutor_pending_contract_card.dart';
import 'package:tution_wala/providers/contracts_provider.dart';
import 'package:tution_wala/service/firestore_service.dart';
import 'package:tution_wala/widgets/contract_card.dart';

class TutorPendingContractsPage extends ConsumerWidget {
  Future<void> handleReject(String id, WidgetRef ref) async {
    await FirestoreService().updateContractState(id, 'reject');
    ref.refresh(tutorContractsProvider);
  }

  Future<void> handleAccept(String id, WidgetRef ref) async {
    await FirestoreService().updateContractState(id, 'ongoing');
    ref.refresh(tutorContractsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contractsAsyncValue = ref.watch(tutorContractsProvider);

    return contractsAsyncValue.when(
      data: (contracts) {
        return ListView.builder(
          itemCount: contracts.length,
          itemBuilder: (context, index) {
            final contract = contracts[index];
            final tutorFuture =
                FirestoreService().getStudentById(contract.studentRef);

            return FutureBuilder(
              future: tutorFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData && contract.state.contains('pending')) {
                  final student = Student.fromFirestore(snapshot.data!);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TutorPendingContractCard(
                      contract: contract,
                      student: student,
                      handleReject: handleReject,
                      handleAccept: handleAccept,
                    ),
                  );
                } else {
                  return const Center();
                }
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        print(stack);
        return Center(child: Text('Error: $error'));
      },
    );
  }
}
