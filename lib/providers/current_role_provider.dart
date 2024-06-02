import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tution_wala/models/student.dart';
import 'package:tution_wala/models/tutor.dart';
import 'package:tution_wala/providers/auth_state_notifier.dart';
import 'package:tution_wala/service/firestore_service.dart';

final studentProvider = FutureProvider<Student>((ref) async {
  final authState = ref.watch(authStateProvider);

  if (authState.isLoggedin && authState.role == 'STUDENT') {
    final firestoreService = FirestoreService();

    final student = Student.fromFirestore(
        await firestoreService.getStudentById(authState.account!.studentRef!));

    return student;
  } else {
    throw Exception('Not a student or not logged in: ${authState.role}');
  }
});

final tutorProvider = FutureProvider<Tutor>((ref) async {
  final authState = ref.watch(authStateProvider);

  if (authState.isLoggedin && authState.role == 'TUTOR') {
    final firestoreService = FirestoreService();

    final tutor = Tutor.fromFirestore(
        await firestoreService.getTutorById(authState.account!.tutorRef!));

    return tutor;
  } else {
    throw Exception('Not a tutor or not logged in');
  }
});
