import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/models/contract.dart';
import 'package:intl/intl.dart';
import 'package:tution_wala/models/tutor.dart';
import 'package:tution_wala/providers/auth_state_notifier.dart';
import 'package:tution_wala/service/firestore_service.dart';

// class WeeklyScheduleNotifier extends StateNotifier<Map<String, List<String>>?> {
//   WeeklyScheduleNotifier() : super(null);

//   void setWeeklySchedule(Map<String, List<String>> schedule) {
//     state = schedule;
//   }
// }

// // Provider for WeeklyScheduleNotifier
// final tutorWeeklyScheduleProvider =
//     StateNotifierProvider<WeeklyScheduleNotifier, Map<String, List<String>>?>(
//         (ref) {
//   return WeeklyScheduleNotifier();
// });

Map<String, List<String>> getWeeklySchedule(
    List<Contract> contracts, List<String> workingDays) {
  // Filter outthe ongoing contracts
  List<Contract> ongoingContracts =
      contracts.where((contract) => contract.state == 'ongoing').toList();

  // Get current date and initialize map to hold the result
  DateTime now = DateTime.now();
  Map<String, List<String>> weeklySchedule = {};

  // Loop through the next 7 days starting from today
  for (int i = 0; i < 7; i++) {
    DateTime currentDay = now.add(Duration(days: i));
    String dayName = DateFormat('EEEE').format(currentDay);

    // Only add the day if the tutor works on this day
    if (workingDays.contains(dayName.toLowerCase())) {
      // Filter contracts that are still active on the current day
      List<String> activeContracts = ongoingContracts
          .where((contract) => contract.endDate.isAfter(currentDay))
          .map((contract) => contract.id ?? '')
          .toList();

      // Add the list of active contract IDs to the map
      weeklySchedule[dayName] = activeContracts;
    }
  }

  return weeklySchedule;
}

final weeklyScheduleProvider =
    FutureProvider<Map<String, List<String>>>((ref) async {
  if (ref.read(authStateProvider).role != 'TUTOR') {
    throw Exception("wrong role");
  }

  final firebaseFirestore = FirestoreService();

  final contractIds = await firebaseFirestore
      .getContractIdsForTutor(ref.read(authStateProvider).account!.tutorRef!);

  final contractsJson =
      await firebaseFirestore.getContractsByContractIds(contractIds);

  final contracts =
      contractsJson.map((e) => Contract.fromFireStore(e)).toList();

  final tutor = Tutor.fromFirestore(await firebaseFirestore
      .getTutorById(ref.read(authStateProvider).account!.tutorRef!));

  final workingDays = tutor.days;

  final weeklySchedule = getWeeklySchedule(contracts, workingDays);
  return weeklySchedule;
});
