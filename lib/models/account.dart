import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Account {
  final String email;
  final String role;
  final String? studentRef;
  final String? tutorRef;

  Account({
    required this.email,
    required this.role,
    required this.studentRef,
    required this.tutorRef,
  });

  factory Account.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Account(
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      studentRef: data['studentRef'],
      tutorRef: data['tutorRef'],
    );
  }
}

final accountProvider = StateProvider<Account?>((ref) => null);
