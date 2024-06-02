import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/models/contract.dart';
import 'package:tution_wala/models/student.dart';
import 'package:tution_wala/models/tutor.dart';
import 'package:tution_wala/providers/contracts_provider.dart';
import 'package:tution_wala/service/firestore_service.dart';
import 'package:tution_wala/widgets/contract_card.dart';
import 'package:tution_wala/widgets/current_contract_card.dart';
import 'package:tution_wala/widgets/ongoing_contract_card.dart';

class TutorCurrentContractsList extends ConsumerWidget {
  Future<void> handleDelete(String id) async {
    await FirestoreService().updateContractState(id, 'terminated-by-tutor');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contractsAsyncValue = ref.watch(tutorContractsProvider);

    return contractsAsyncValue.when(
      data: (contracts) {
        return ListView.builder(
          itemCount: contracts.length + 1,
          itemBuilder: (context, index) {
            if (index < contracts.length) {
              final contract = contracts[index];
              final tutorFuture =
                  FirestoreService().getStudentById(contract.studentRef);

              return FutureBuilder(
                future: tutorFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData && contract.state.contains('ongoing')) {
                    final student = Student.fromFirestore(snapshot.data!);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CurrentContractCard(
                        contract: contract,
                        student: student,
                        handleTerminate: handleDelete,
                      ),
                    );
                  } else {
                    return const Center();
                  }
                },
              );
            } else
              return SizedBox(
                height: 100,
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
