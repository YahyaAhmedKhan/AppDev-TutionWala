import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Account {
  final String email;
  final String role;
  final String? studentRef;
  final String? tutorRef;
  final String? id;

  Account(
      {required this.email,
      required this.role,
      this.studentRef,
      this.tutorRef,
      this.id});

  factory Account.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Account(
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      studentRef: data['studentRef'],
      tutorRef: data['tutorRef'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role,
      'studentRef': studentRef,
      'tutorRef': tutorRef,
    };
  }
}

final accountProvider = StateProvider<Account?>((ref) => null);
